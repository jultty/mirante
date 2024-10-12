-- <secret> must be edited and safely stored before execution
ALTER DATABASE postgres SET "app.jwt_secret" TO '<jwt-secret>';

create schema security;

create role base_user nologin;
grant base_user to authenticator;

grant usage on schema mirante to base_user;

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

create function
security.encrypt_password() returns trigger as $$
begin
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

create function get_token(out token text) as $$
  select mirante.sign(
    row_to_json(r), current_setting('app.jwt_secret')
  ) as token
  from (
    select
      'my_role'::text as role,
      -- 1800 seconds = 30 minutes
      extract(epoch from now())::integer + 1800 as exp
  ) r;
$$ language sql;

create function
login(email text, pass text, out token text) as $$
declare
  _role name;
begin
  select security.user_role(email, password) into _role;
  if _role is null then
    raise invalid_password using message = 'Invalid email or password';
  end if

  select sign(
    row_to_json(r), current_setting('app.jwt_secret')
  ) as token from (
    select _role as role, login.email as email,
      extract(epoch from now())::integer + 60*30 as exp
  ) r
  into token;

end;
$$ language plpgsql security definer;

grant execute on function login(text, text) to anonymous;
