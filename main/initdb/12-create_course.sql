create table mirante.course (
  id int primary key generated by default as identity,
  name text not null,
  author int references account(id),
  creation_date timestamptz not null,
  expiry_date timestamptz,
  active boolean not null default true,
  locked boolean not null default false,
  expired boolean not null default false
);