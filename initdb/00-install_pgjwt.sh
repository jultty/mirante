#!/bin/sh

apt-get update
apt-get install ca-certificates git postgresql-server-dev-all
git clone https://github.com/michelp/pgjwt
cd pgjwt || exit 1
make install
