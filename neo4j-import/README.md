# Loading in bulk

Type `make` to load in a sample dataset into `instacart.db`. Type `make full` to load the full dataset into `instacart.full.db`.

Assumes that the instacart data tar and neo4j are both inside your home directory (`~`) somewhere. If not, edit the three `shell find` statements at the top of the Makefile, replacing the `~` with a parent directory for each of the three files (`neo4j-admin`, `neo4j/data/databases`, and `instacart....tar.gz`)