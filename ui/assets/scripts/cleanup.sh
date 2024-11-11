#!/usr/bin/env sh

file="$1"

tac "$file" | sed 's/^exports\..*=.*;$//' | tac > "../../javascript/$(basename "$file")"
rm -v "$file"
