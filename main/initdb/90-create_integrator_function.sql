-- this is a temporary role and endpoint for a specific course assignment

create role integrator;
grant usage on schema mirante to integrator;
grant integrator to authenticator;

grant usage on schema security to integrator;

insert into security.user (email, password, role) values
  ('rgpet@mirante.jutty.dev', 'nZmZm8BgA', 'integrator');

create or replace function mirante.rgpet(user_email text) returns json as $$
declare
    usr record;
begin
    select email, role
    into usr
    from security."user"
    where email = user_email;
    if not found then
      raise exception 'Email não encontrado; %', user_email;
    end if;

    return json_build_object(
        'user', json_build_object(
            'email', usr.email,
            'role', usr.role
        )
    );
end
$$ language plpgsql security definer;

revoke all privileges on function rgpet(text) from public;
grant execute on function rgpet(text) to integrator;
