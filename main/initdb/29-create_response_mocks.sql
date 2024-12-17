create role "example00@mirante.jutty.dev";
grant usage on schema mirante to "example00@mirante.jutty.dev";
grant "example00@mirante.jutty.dev" to authenticator;
grant base_user to "example00@mirante.jutty.dev";

insert into security.user (email, password, role) values ('example00@mirante.jutty.dev', 'accordion', 'example00@mirante.jutty.dev');

insert into mirante.course (name, creation_user) values ('Example Course 00', 'example00@mirante.jutty.dev');
insert into mirante.exercise_set (name, course, creation_user) values ('Exercise Set Example 00', 1, 'example00@mirante.jutty.dev');
insert into mirante.exercise (instruction, set, creation_user) values ('Exercise Example 00', 1, 'example00@mirante.jutty.dev');

insert into mirante.option (content, correct, exercise, creation_user) values
  ('Option Example 00a', false, 1, 'example00@mirante.jutty.dev'),
  ('Option Example 00b', false, 1, 'example00@mirante.jutty.dev'),
  ('Option Example 00c', true, 1, 'example00@mirante.jutty.dev'),
  ('Option Example 00d', false, 1, 'example00@mirante.jutty.dev');


create role "example01@mirante.jutty.dev";
grant usage on schema mirante to "example01@mirante.jutty.dev";
grant "example01@mirante.jutty.dev" to authenticator;
grant base_user to "example01@mirante.jutty.dev";

insert into security.user (email, password, role) values ('example01@mirante.jutty.dev', 'accordion', 'example01@mirante.jutty.dev');

insert into mirante.course (name, creation_user) values ('Example Course 01', 'example01@mirante.jutty.dev');
insert into mirante.exercise_set (name, course, creation_user) values ('Exercise Set Example 01', 1, 'example01@mirante.jutty.dev');
insert into mirante.exercise (instruction, set, creation_user) values ('Exercise Example 01', 1, 'example01@mirante.jutty.dev');

insert into mirante.option (content, correct, exercise, creation_user) values
  ('Option Example 01a', false, 1, 'example01@mirante.jutty.dev'),
  ('Option Example 01b', false, 1, 'example01@mirante.jutty.dev'),
  ('Option Example 01c', true, 1, 'example01@mirante.jutty.dev'),
  ('Option Example 01d', false, 1, 'example01@mirante.jutty.dev');


insert into mirante.response
  (option,  creation_date,               creation_user) values
  (2,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-01-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (2,      '2024-02-08T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-02-14T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-02-24T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-03-04T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-03-06T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-03-09T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-03-12T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-03-14T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (4,      '2024-04-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-04-08T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-04-12T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-04-14T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-04-25T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-06-11T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-06-11T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-06-21T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-06-23T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-06-27T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-06-30T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-07-11T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-07-15T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-07-19T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-07-22T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-07-28T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-07-29T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-08-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-08-09T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-08-23T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-08-29T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-10-03T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (1,      '2024-10-03T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-10-13T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-10-13T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-10-13T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-10-13T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (3,      '2024-11-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-11-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-11-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-11-02T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-11-20T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-11-20T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-11-20T18:00:00-03:00', 'example00@mirante.jutty.dev'),

  (2,      '2024-12-01T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-12-01T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-12-10T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-12-10T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-12-10T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-12-17T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (4,      '2024-12-20T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-12-20T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (2,      '2024-12-27T18:00:00-03:00', 'example00@mirante.jutty.dev'),
  (3,      '2024-12-27T18:00:00-03:00', 'example00@mirante.jutty.dev');

insert into mirante.response
  (option,  creation_date,               creation_user) values
  (6,      '2024-01-02T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-01-03T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-01-04T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-01-07T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-01-11T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-01-15T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-01-18T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-01-24T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (6,      '2024-02-08T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-02-14T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-02-24T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (7,      '2024-03-04T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-03-06T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-03-09T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-03-12T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-03-14T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (8,      '2024-04-02T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-04-08T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-04-12T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-04-14T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-04-25T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (6,      '2024-06-11T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-06-11T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-06-21T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-06-23T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-06-27T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-06-30T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (6,      '2024-07-11T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-07-15T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-07-19T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-07-22T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-07-28T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-07-29T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (7,      '2024-08-02T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-08-09T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-08-23T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-08-29T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (6,      '2024-10-04T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (5,      '2024-10-09T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-10-13T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-10-18T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-10-23T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-10-25T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (7,      '2024-11-02T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-11-05T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-11-18T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-11-19T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-11-20T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-11-28T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-11-29T18:00:00-03:00', 'example01@mirante.jutty.dev'),

  (6,      '2024-12-01T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-12-03T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-12-08T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-12-10T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-12-12T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (7,      '2024-12-17T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-12-20T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-12-22T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (6,      '2024-12-27T18:00:00-03:00', 'example01@mirante.jutty.dev'),
  (8,      '2024-12-31T18:00:00-03:00', 'example01@mirante.jutty.dev');
