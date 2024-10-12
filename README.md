The following must be defined in the shell that runs `docker compose`:

```sh
export POSTGRES_USER=mirante
export POSTGRES_DB=mirante
export POSTGRES_PASSWORD="$(< /dev/urandom tr -dc A-Za-z0-9 | head -c64)"
export MIRANTE_JWT_SECRET="$(< /dev/urandom tr -dc A-Za-z0-9 | head -c32)"
```

Values above are just examples of how you could generate a random value using Unix tools. You should securely store a backup copy of this information elsewhere.

The `POSTGRES_PASSWORD` is not really used, as PostgREST will actually connect directly through a socket. The JWT secret however is particularly sensitive and, if leaked, will allow an attacker to sign a token on behalf of the system.
