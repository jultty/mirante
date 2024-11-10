#!/usr/bin/env sh

echo "[cleanup] Starting"
pwd

for i in ../../*.js; do
  echo "[cleanup] Cleaning $i"
  tac "$i" | sed 's/^exports\..*=.*;$//' | tac > "$i.temp"
  mv -vf "$i.temp" "$i"
done

echo "[cleanup] Done"
