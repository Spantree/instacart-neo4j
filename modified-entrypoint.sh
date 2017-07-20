#!/usr/bin/env bash

cat /var/lib/instacart/terms_conditions.md
cat /var/lib/instacart/citation.md

echo "See the full dataset here: https://www.instacart.com/datasets/grocery-shopping-2017"
sleep 5

exec /docker-entrypoint.sh "$@"
