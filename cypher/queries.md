## Dumpster Diving

And here are the queries from the dumpster diving section of the talk,
in order.

### What's getting ordered

```
MATCH (p:Product)-[r:IN_ORDER]->()
RETURN p.name, count(r) AS timesOrdered
ORDER BY timesOrdered DESC
LIMIT 20
```

### Get Departments
```
MATCH (d:Department) return d.name
```

### Department-Based Vegetarian
```
MATCH (u:User)
WITH u LIMIT 1
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:IN]->(d:Department)
WITH u, collect(DISTINCT d.name) AS departments
WHERE NOT "meat seafood" IN departments
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p:Product)
RETURN p.name, count(*) AS overlap
ORDER BY overlap DESC;
```

### Get department and aisle for Beef Jerky
```
MATCH (p:Product {name: "Original Beef Jerky"}),
     (a:Aisle)<-[:ON]-(p)-[:IN]->(d:Department)
RETURN p,a,d
```

### Get aisles with meat or seafood in the name
```
MATCH (a:Aisle)
WHERE a.name CONTAINS 'meat'
OR a.name CONTAINS 'seafood'
RETURN DISTINCT a.name
```

### Aisles to avoid
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
or a.name contains 'seafood' or d.name contains 'meat' or d.name contains 'jerky')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
return DISTINCT a.name
```

### Products "Vegetarians" buy
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
with collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User) WITH u, avoidAisles limit 1000
match (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p:Product)
RETURN p.name, count(*) AS overlap
ORDER BY overlap DESC
```

### Potential vegetarians
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
MATCH (u:User) WITH u, avoidAisles limit 100
match (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
return u
```

### Total "Vegetarians"
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
WITH collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
RETURN count(u)
```

### Label "Vegetarians"
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
WITH collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
SET u:Vegetarian
```

### Products "Vegans" buy
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky'
       OR d.name CONTAINS 'dairy')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
WITH collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User) WITH u, avoidAisles limit 10000
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p:Product)
RETURN p.name, count(*) AS overlap
ORDER BY overlap DESC
```

### Total "Vegans"
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky'
       OR d.name CONTAINS 'dairy')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
WITH collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
RETURN count(u)
```

### Label Vegans
```
MATCH (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
WHERE (a.name CONTAINS 'meat'
       OR a.name CONTAINS 'seafood'
       OR d.name CONTAINS 'meat'
       OR a.name CONTAINS 'jerky'
       OR d.name CONTAINS 'dairy')
AND NOT a.name CONTAINS 'alternatives'
AND NOT a.name CONTAINS 'marinades'
WITH collect(DISTINCT a.name) AS avoidAisles
MATCH (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) AS aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
SET u:Vegan
```

### Vegans like me (Round 1)
```
MATCH (u:User:Vegan {id: "92"})-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p:Product),
      (other:User:Vegan)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p)
RETURN u, other, count(p) AS overlap
ORDER BY overlap DESC
LIMIT 5
```

### Seeing overlap between two vegans
```
MATCH (u:User:Vegan {id: "92"})-[:ORDERED]->(o:Order)<-[:IN_ORDER]-(p:Product)
RETURN u, o, p
UNION
MATCH (u:User:Vegan {id: "196224"})-[:ORDERED]->(o:Order)<-[:IN_ORDER]-(p:Product)
RETURN u, o, p
```

### Vegans like me (Round 2)
```
MATCH (u:User:Vegan {id: "92"})-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p:Product),
      (other:User:Vegan)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(p)
WITH u, other, count(DISTINCT p) AS overlap
ORDER BY overlap DESC
RETURN u, other, overlap
LIMIT 5
```

### Get a user's order history graph
```
MATCH (u:User {id: "4"})-[:ORDERED]->(o:Order)<-[:IN_ORDER]-(p:Product)
RETURN u, o, p
```

### What's purchased with cups?
```
MATCH (p:Product {name: "Red Plastic Cups"})-[:IN_ORDER]->(:Order)<-[:IN_ORDER]-(otherProduct:Product)
RETURN otherProduct.name, count(*) as occurrences
ORDER BY occurrences DESC
```

### What alcoholic beverages are purchased with cups?
```
MATCH (p:Product)-[:IN_ORDER]->(o:Order),
      (d:Department {name: "alcohol"})<-[:IN]-(otherProduct:Product)-[:IN_ORDER]->(o)
      WHERE p.name CONTAINS "Plastic Cups"
RETURN otherProduct.name, count(*) AS occurrences
ORDER BY occurrences DESC
```

### Buying cups and Sauv Blanc? What else should you buy?
```
MATCH (o:Order)<-[:IN_ORDER]-(p:Product),
 (o)<-[:IN_ORDER]-(p2:Product {name: "Sauvignon Blanc"}),
 (o)<-[:IN_ORDER]-(otherp:Product)
 WHERE otherp <> p AND otherp <> p2 AND p.name CONTAINS "Plastic Cups"
 RETURN otherp.name, count(*) AS occurrences
 ORDER BY occurrences DESC
 LIMIT 10
```

.... more to come. In the meantime, check out the speaker notes in [the
slides](https://docs.google.com/presentation/d/1C3iLwoMXUAwFLNbCOs8Hf8jE2pHATKalL7hGU72Mqhw/edit?usp=sharing).
