-- this is a temporary role and endpoint for a specific course assignment

create role integrator;
grant usage on schema mirante to integrator;
grant integrator to authenticator;
