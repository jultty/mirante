create table mirante.version (
  id int primary key generated by default as identity,

  deprecated boolean not null default false,
  current boolean not null default false,
  tag text not null,
  date timestamptz not null
);

insert into mirante.version (tag, deprecated, current, date) values
  ('v0.2.0', true, false, '2024-03-09'),
  ('v0.3.0', true, false, '2024-04-23'),
  ('v0.4.0', true, false, '2024-10-12'),
  ('v0.5.0', true, false, '2024-11-19'),
  ('v0.6.0', false, true, '2024-12-16');

grant select on mirante.version to anonymous;
grant select on mirante.version to base_user;
