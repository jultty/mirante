alter default privileges revoke execute on functions from public;
-- See: https://docs.postgrest.org/en/stable/explanations/db_authz.html#functions

create schema mirante;

create role anonymous nologin;
grant usage on schema mirante to anonymous;

-- <secret> must be edited and safely stored before execution
create role authenticator noinherit nologin;
grant anonymous to authenticator;
