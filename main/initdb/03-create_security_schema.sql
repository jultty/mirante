create schema security;

create role anonymous noinherit;
grant usage on schema mirante to anonymous;

create role authenticator noinherit;
grant anonymous to authenticator;

create table
security.user (
  email     text primary key check ( email ~* '^.+@.+\..+$' ),
  password  text not null check (length(password) < 512),
  role      name not null check (length(role) < 512)
);

create function
security.check_role_exists() returns trigger as $$
  begin
    if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
      raise foreign_key_violation using message =
        'Unknown database role: ' || new.role;
      return null;
    end if;
    return new;
  end
$$ language plpgsql;

create constraint trigger ensure_user_role_exists
  after insert or update on security.user
  for each row
  execute procedure security.check_role_exists();

create extension pgcrypto;
create extension pgjwt;

create function
security.encrypt_password() returns trigger as $$
begin
  if length(new.password) < 8 then
    raise invalid_password using message = 'Password is too short';
  end if;
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger encrypt_password
  before insert or update on security.user
  for each row
  execute procedure security.encrypt_password();

create function
security.user_role(email text, password text) returns name
  language plpgsql
  as $$
    begin
    return (
      select role from security.user
      where security.user.email = user_role.email
      and security.user.password = crypt(user_role.password, security.user.password)
    );
    end;
  $$;

create function
login(email text, password text, out token text) as $$
declare
  _role name;
begin
  select security.user_role(email, password) into _role;
  if _role is null then
    raise invalid_password using message = 'Invalid role, user or password';
  end if;

  select sign(
      row_to_json(r), current_setting('app.settings.jwt_secret')
    ) as token
    from (
      select _role as role,
      extract(epoch from now())::integer + 60*60 as exp
    ) r
    into token;
end;
$$ language plpgsql security definer;

grant execute on function login(text, text) to anonymous;

create or replace function signup(email text, password text) returns json as $$
declare
    usr record;
begin

    if not exists (select * from pg_roles where rolname = email) then
        execute format('create role %I', email);
        execute format('grant usage on schema mirante to %I;', email);
        execute format('grant insert on mirante.course to %I', email);
        execute format('grant %I to authenticator', email);
    else
        raise foreign_key_violation using message = 'Role exists';
    end if;

    insert into security."user" as u
    (email, password, role) values ($1, $2, $1)
    returning *
   	into usr;

    return json_build_object(
        'email', usr.email,
        'token', sign(
            json_build_object(
                'email', usr.email,
                'role', usr.role,
                'exp', extract(epoch from now())::integer + 60*30 -- 60*x where x = minutes
            ),
            current_setting('app.settings.jwt_secret')
        )
    );
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text) from public;
grant execute on function signup(text, text) to anonymous;
