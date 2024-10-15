# syntax = docker/dockerfile:1

FROM docker.io/library/postgres:17
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

COPY initdb /docker-entrypoint-initdb.d
RUN apt-get update \
    && apt-get install -y \
    git postgresql-server-dev-all
RUN cd tmp \
    && git clone https://github.com/michelp/pgjwt \
    && cd pgjwt \
    && make install \
    && cd
