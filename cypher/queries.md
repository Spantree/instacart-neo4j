### Loading the CSV Data
The load queries below rely on several csv files from the dataset to be
available to Neo4j. They are documented in the order you'll want to run
them. Indexes should be created before inserting data.

If performance is an issue, be sure to read [this
section](https://neo4j.com/developer/guide-import-csv/#_important_tips_for_load_csv)
of the guide on `IMPORT CSV`.

#### Indexes
Super important. Otherwise the rest is going to be real slow. Each line
needs to be executed separately in the neo4j browser.
```
CREATE INDEX ON :Department(name);
CREATE INDEX ON :Department(id);
CREATE INDEX ON :Aisle(id);
CREATE INDEX ON :Aisle(name);
CREATE INDEX ON :Product(name);
CREATE INDEX ON :Product(id);
CREATE INDEX ON :Order(id);
CREATE INDEX ON :OrderedItem(id);
CREATE INDEX ON :User(id);
```

Verify indexes are present and `ONLINE` with the following command in
the neo4j browser:
```
:sysinfo
```

#### Load Departments
```
LOAD CSV WITH HEADERS FROM "file:///departments.csv" as line
CREATE (:Department {id: line.department_id, name: line.department})
```
_Time on my machine: 500ms_

#### Load Aisles
```
LOAD CSV WITH HEADERS FROM "file:///aisles.csv" as line
CREATE (:Aisle {id: line.aisle_id, name: line.aisle})
```
_Time on my machine: 500ms_

#### Load Products
Using the scrubbed products file generated from the
`./prep-data.sh` file. (scrubbed for extra `"`s)
```
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///products.scrubbed.csv" AS line
MATCH (a:Aisle {id: line.aisle_id}), (d:Department {id: line.department_id})
MERGE (a)<-[:ON]-(p:Product {id: line.product_id, name: line.product_name})-[:IN]->(d)
```
_Time on my machine: 18s_

#### Load Orders
This one only loads a subset of the order data. Tweak the limit to
adjust how many orders to bring in.
```
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///orders.csv" as line
WITH line LIMIT 34000
MERGE (u:User {id: line.user_id})
MERGE (u)-[:ORDERED]->(o:Order {
  id: line.order_id,
  orderNumber: TOINT(line.order_number),
  dayOfWeek: TOINT(line.order_dow),
  hourOfDay: TOINT(line.order_hour_of_day)
});
```
_Time on my machine: 9s_

#### Load Order Items
```
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///order_products__train.csv" as line with line
MATCH (o:Order {id: line.order_id}), (p:Product {id: line.product_id})
MERGE (oi:OrderedItem {id: line.order_id + '-' + line.product_id})
  ON CREATE SET oi.addToCartOrder=line.add_to_cart_order, oi.reordered=line.reordered
MERGE (oi)-[:IN_ORDER]->(o)
MERGE (oi)-[:ITEM]->(p)
```
_Time on my machine: 51s_

```
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///order_products__prior.csv" as line with line
MATCH (o:Order {id: line.order_id}), (p:Product {id: line.product_id})
MERGE (oi:OrderedItem {id: line.order_id + '-' + line.product_id})
  ON CREATE SET oi.addToCartOrder=line.add_to_cart_order, oi.reordered=line.reordered
MERGE (oi)-[:IN_ORDER]->(o)
MERGE (oi)-[:ITEM]->(p)
```
_Time on my machine: 19m_
