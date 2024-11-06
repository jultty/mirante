<img alt="An icon of a lighthouse on a cliff top with two light beams pointing outwards" src="ui/assets/images/icon.png" align="right">

# Mirante

Mirante is a system to collect and analyze data related to the teaching-learning process. It can store exercise sets and then transform the data from the responses into meaningful information.

## Usage

Mirante listens for HTTP requests on port `3031` by default and currently provides access to the following endpoints:

- `/` returns the OpenAPI specification on a `GET` request
- `/version` returns the version history upon a `GET` request. For the current version, use `/version?current=is.true`
- `/rpc/signup` receives `POST` requests containg a JSON body with the fields `email` and `password`. If account creation is successful, an authentication token will be returned that you can use to authenticate further requests
- `/rpc/login` receives `POST` requests containing a JSON body with the fields `email` and `password`. If the credentials check out for an existing account, an authentication token is returned

## Development

Mirante was implemented using a thin layer over its database. This layer is [PostgREST](https://docs.postgrest.org/en/stable/index.html), which acts as its web server. However, the actual engine behind both PostgREST and Mirante is [PostgreSQL](https://www.postgresql.org/), where all data structures and logic actually live. These are defined using [SQL](https://www.postgresql.org/docs/current/sql.html) and [PL/pgSQL](https://www.postgresql.org/docs/current/plpgsql.html).

To facilitate reproducing and deploying these two elements together, Mirante is tested and distributed as a set of two Docker containers that you can run together with [Docker Compose](https://docs.docker.com/compose).

The following environment variables must be defined in the shell that will start the containers:

```sh
export POSTGRES_USER=mirante
export POSTGRES_DB=mirante
export POSTGRES_PASSWORD="$(< /dev/urandom tr -dc A-Za-z0-9 | head -c64)"
export MIRANTE_JWT_SECRET="$(< /dev/urandom tr -dc A-Za-z0-9 | head -c64)"
```

The values above are just examples of how you could generate a random value using Unix tools. You should securely store a backup copy of this information elsewhere if you are running this in production.

The `POSTGRES_PASSWORD` is not really used, as PostgREST will actually connect locally through a socket. The JWT secret however is particularly sensitive and, if leaked, will allow an attacker to sign a token on behalf of the system.

With these values in place, you can use `docker compose` to start both containers. Due to how the `compose.yml` file is configured, the PostgreSQL database server will start first. Once it's ready to accept connections, the container with the PostgREST web server comes up and connects to it.

When you run `docker compose`, a directory will be created at `/var/mirante/data` to store the database data. While `docker compose down` will dispose of the containers, the PostgreSQL server's databases will only be recreated if you delete this directory. Therefore, if you modify them during development, you'll want to delete this directory before rebuilding.

If you'd like to connect to the database in order to inspect the present state, you can use `docker exec -it mirante-db bash` to get a terminal inside the container. From there, use `psql -U <user>` where `<user>` is replaced by the value of `POSTGRES_USER` as set above when configuring the shell's environment variables. Because this is a local connection from inside the container, you will not be prompted for a password.
