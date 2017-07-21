## Cypher Queries

Below are the cypher queries used in the slides as well as some that
were left out of the slides for brevity but are needed to load the
dataset.

### Loading the CSV Data

The load queries below rely on several csv files from the dataset to be
available to Neo4j. They are documented in the order you'll want to run
them.

#### Load Departments
```
LOAD CSV WITH HEADERS FROM "file:///departments.csv" as line
CREATE (:Department {id: line.department_id, name: line.department})
```

#### Load Aisles
```
LOAD CSV WITH HEADERS FROM "file:///aisles.csv" as line
CREATE (:Aisle {id: line.aisle_id, name: line.aisle})
```

#### Load Products
```
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///products.csv" AS line
WITH line
MATCH (a:Aisle {id: line.aisle_id}), (d:Department {id: line.department_id})
MERGE (a)<-[:ON]-(p:Product {id: line.product_id, name: line.product_name})-[:IN]->(d)
```

#### Load Orders
This one only loads a subset of the order data. Tweak the limit to
adjust how many orders to bring in.
```
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///orders.csv" AS line
WITH line LIMIT 34000
MERGE (u:User)...
```

#### Load Order Items
```
```
