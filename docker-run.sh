docker run \
  -d \
  --name mirante-pgr \
  -e POSTGRES_PASSWORD="$(gpg --gen-random 30)" \
  -p 5432:5432 \
  postgres:17.0-alpine3.20 \
  postgres
