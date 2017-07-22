# 400 trash bags of grocery receipts + Neo4j

Slides, help loading data, and sample queries from the [meetup
talk](https://www.meetup.com/windy-city-graphdb/events/240348871/).

## Running neo4j with the Instacart data

### Prerequisites

To run this locally, you'll need
* a local docker environment
* the instacart data (in tar.gz format) downloaded and moved to the root
  of this project directory

You can download the data
[here](https://www.instacart.com/datasets/grocery-shopping-2017), and
must agree to the [terms and
conditions](https://gist.github.com/jeremystan/582eba13d6ee27ed465c43dc78934700).
For more information about the contents of the files, see this [data
dictionary](https://gist.github.com/jeremystan/c3b39d947d9b88b3ccff3147dbcf6c6b).

If you don't want to use docker, you can also run neo4j in other ways,
but for the ease of setup, I've chosen to use docker. The biggest thing
you'll have to do manually if you don't use docker is move the raw data
to the equivalent of `/var/lib/neo4j/import` for the method you're
running neo4j.

### Prepping the data

There's a script, `prep-data.sh`, that will untar the data and then
scrub a CSV that has improperly escaped doublequotes. Once you've run
that script, you should be able to run the docker container and start
executing the import queries.

All in all that should look like:
```
./prep-data.sh
docker-compose up
```

Now check out the `cypher` directory of this project for queries to
import the data and all the queries I use in the presentation.
