## Dumpster Diving

And here are the queries from the dumpster diving section of the talk,
in order.

### Get Departments
```
MATCH (d:Department) return d.name
```

### Department-Based Vegetarian
```
MATCH (u:User)
WITH u LIMIT 1
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:IN]->(d:Department)
WITH u, collect(DISTINCT d.name) as departments
WHERE NOT "meat seafood" in departments
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(p:Product)
RETURN p.name, count(*) as overlap
order by overlap desc;
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
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
MATCH (u:User) WITH u, avoidAisles limit 1000
match (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(p:Product)
RETURN p.name, count(*) as overlap
order by overlap desc
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
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
match (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
RETURN count(u)
```

### Label "Vegetarians"
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
match (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
SET u:Vegetarian
```

### Products "Vegans" buy
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky'
       or d.name contains 'dairy')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
MATCH (u:User) WITH u, avoidAisles limit 10000
match (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
WITH u
MATCH (u)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(p:Product)
RETURN p.name, count(*) as overlap
order by overlap desc
```

### Total "Vegans"
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky'
       or d.name contains 'dairy')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
match (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
return COUNT(u)
```

### Label Vegans
```
match (a:Aisle)<-[:ON]-(:Product)-[:IN]->(d:Department)
where (a.name contains 'meat'
       or a.name contains 'seafood'
       or d.name contains 'meat'
       or a.name contains 'jerky'
       or d.name contains 'dairy')
and not a.name contains 'alternatives'
and not a.name contains 'marinades'
with collect(DISTINCT a.name) as avoidAisles
match (u:User)-[:ORDERED]->(:Order)<-[:IN_ORDER]-(:OrderedItem)-[:ITEM]->(:Product)-[:ON]->(a:Aisle)
WITH u, collect(DISTINCT a.name) as aisles, avoidAisles
WHERE none(a IN aisles WHERE a IN avoidAisles)
SET u:Vegan
```

.... more to come. In the meantime, check out the speaker notes in [the
slides](https://docs.google.com/presentation/d/1C3iLwoMXUAwFLNbCOs8Hf8jE2pHATKalL7hGU72Mqhw/edit?usp=sharing).
