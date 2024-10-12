create or replace function signup(email text, password text) returns json as $$
declare
    usr record;
begin
    insert into security."user" as u
    (email, password, role) values ($1, $2, 'base_user')
    returning *
   	into usr;

    return json_build_object(
        'user', json_build_object(
            'email', usr.email
        ),
        'token', sign(
            json_build_object(
                'email', usr.email,
                'role', usr.role,
                'exp', extract(epoch from now())::integer + 60*30 -- 60*x where x = minutes
            ),
            current_setting('app.jwt_secret')
        )
    );
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text) from public;
grant execute on function signup(text, text) to anonymous;
