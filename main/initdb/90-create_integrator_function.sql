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
    select email, name, city, occupation, cep, cpf
    into usr
    from security."user"
    where email = user_email;
    if not found then
      raise exception 'Email não encontrado; %', user_email;
    end if;

    return json_build_object(
        'user', json_build_object(
            'email', usr.email,
            'name', usr.name,
            'city', usr.city,
            'occupation', usr.occupation,
            'cep', usr.cep,
            'cpf', usr.cpf
        )
    );
end
$$ language plpgsql security definer;

revoke all privileges on function rgpet(text) from public;
grant execute on function rgpet(text) to integrator;

create role "user@mirante.example";
create role "teste@mirante.example";
create role "teste2@mirante.example";
create role "teste3@mirante.example";
create role "teste4@mirante.example";

insert into security.user (email, role, password, name, occupation, city, cep, cpf) values
  ('user@mirante.example', 'user@mirante.example', 'test_value', 'Sônia Guimarães', 'Professora de Física', 'São José dos Campos', '12244595', '16696119060'),
  ('teste@teste.jutty.dev', 'teste@mirante.example', 'test_value', 'Maria Bernardes', 'Tradutora', 'Jacareí', '12318260', '69111075040'),
  ('teste2@teste.jutty.dev', 'teste2@mirante.example', 'test_value', 'Lucia Silva', 'Programadora', 'Guararema', '08900000', '43985191069'),
  ('teste3@teste.jutty.dev', 'teste3@mirante.example', 'test_value', 'Ana Beatriz de Sousa', 'Segurança', 'São Paulo', '05368030', '48600816092'),
  ('teste4@teste.jutty.dev', 'teste4@mirante.example', 'test_value', 'Julia Pereira', 'Técnica em Automação', 'Poá', '08554230', '24521311059');
