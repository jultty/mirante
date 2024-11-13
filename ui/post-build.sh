#!/usr/bin/env sh

file="$1"

mv "$file" "../../public/assets/scripts/javascript/$(basename "$file")"
