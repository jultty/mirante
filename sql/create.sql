alter default privileges revoke execute on functions from public;
-- See: https://docs.postgrest.org/en/stable/explanations/db_authz.html#functions

create schema mirante;

create table mirante.version (
  id int primary key generated by default as identity,
  deprecated boolean not null default false,
  current boolean not null default false,
  tag text not null,
  date timestamptz not null
);

insert into mirante.version (tag, deprecated, current, date) values
  ('v0.2.0', true, false, '2024-03-09'),
  ('v0.3.0', false, false, '2024-04-23'),
  ('v0.4.0', false, true, '2024-10-12');

create role anonymous nologin;
grant usage on schema mirante to anonymous;
grant select on mirante.version to anonymous;

-- <secret> must be edited and safely stored before execution
create role authenticator noinherit login password '<secret>';
grant anonymous to authenticator;
