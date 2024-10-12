create or replace function signup(email text, password text) returns json as $$
declare
    usr record;
begin
    insert into security."user" as u
    (email, password) values ($1, $2, $3)
    returning *
   	into usr;

    return json_build_object(
        'me', json_build_object(
            'id', usr.id,
            'email', usr.email,
            'role', 'base_user'
        ),
        'token', pgjwt.sign(
            json_build_object(
                'email', usr.email,
                'role', usr.role,
                'exp', extract(epoch from now())::integer + 60*30 -- 60*x where x = minutes
            ),
            settings.get('jwt_secret')
        )
    );
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text) from public;
grant execute on function signup(text, text) to anonymous;
