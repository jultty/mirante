#!/usr/bin/env sh

# password provided here is not used later
docker run \
  -d \
  --name mirante-pg \
  -e POSTGRES_PASSWORD="$(gpg --gen-random 30)" \
  -p 5432:5432 \
  postgres:17.0-alpine3.20 \
  postgres
