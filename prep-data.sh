#!/usr/bin/env bash

read -d '' no_file_msg <<- EOF
This script is meant to prepare a unpack and scrub the of the Instacart data
for importing into neo4j. It doesn't automatically download data due to
restrictions in the terms and conditions, so you must download the data set
and place it in the root of this project before running the script.

The data can be found here: https://www.instacart.com/datasets/grocery-shopping-2017

Download and move that file to the current directory without renaming it.
EOF

curr_dir=`pwd`
instacart_file_name=instacart_online_grocery_shopping_2017_05_01.tar.gz
instacart_dir=instacart_2017_05_01


if [ ! -f "$curr_dir/$instacart_file_name" ]
then
  echo "$no_file_msg"
  exit 1
fi

echo "Found $instacart_file_name."

echo "Untarring $instacart_file_name."
tar -xvf $instacart_file_name

# TODO check for failed untarring here and exit early

echo "Scrubbing product CSV for unescaped quotes."
sed 's/\""/\"/g' $curr_dir/$instacart_dir/products.csv > $curr_dir/$instacart_dir/products.scrubbed.csv
echo "Completed Scrubbing."

echo "Data prep complete. Run docker-compose up to start neo4j."
