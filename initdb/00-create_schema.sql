alter default privileges revoke execute on functions from public;

create schema mirante;

create role anonymous nologin;
grant usage on schema mirante to anonymous;

create role authenticator noinherit nologin;
grant anonymous to authenticator;
