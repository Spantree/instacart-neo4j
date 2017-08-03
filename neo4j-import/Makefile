NEO4J_DATA_DIR := $(shell find ~ -path "*neo4j-*-3.*/data/databases")
NEO4J_ADMIN := $(shell find ~ -name neo4j-admin)
INSTA_DATA := $(shell find ~ -name instacart_online_grocery_shopping_2017_05_01.tar.gz)
TARGETS := \
	instacart_2017_05_01/orders.csv \
	instacart_2017_05_01/aisles.csv \
	instacart_2017_05_01/departments.csv \
	instacart_2017_05_01/products.scrubbed.csv \
  instacart_2017_05_01/order_products__train.csv
FULL_TARGET := instacart_2017_05_01/order_products__prior.csv

sample: $(NEO4J_DATA_DIR)/instacart.db

full: $(NEO4J_DATA_DIR)/instacart.full.db

$(NEO4J_DATA_DIR)/instacart.full.db: $(TARGETS) $(FULL_TARGET)
	$(NEO4J_ADMIN) import \
	--database instacart.full.db \
	--id-type string \
	--ignore-duplicate-nodes true \
	--nodes:User "users_headers.csv,instacart_2017_05_01/orders.csv" \
	--nodes:Aisle "aisles_headers.csv,instacart_2017_05_01/aisles.csv" \
	--nodes:Department "departments_headers.csv,instacart_2017_05_01/departments.csv" \
	--nodes:Product "products_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--nodes:Order "orders_headers.csv,instacart_2017_05_01/orders.csv" \
	--nodes:OrderedItem "order_products_headers.csv,instacart_2017_05_01/order_products__prior.csv,instacart_2017_05_01/order_products__train_id.csv" \
	--relationships:ON "products_aisles_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--relationships:IN "products_departments_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--relationships:ORDERED "users_orders_headers.csv,instacart_2017_05_01/orders.csv" \
	--relationships:IN_ORDER "order_products_order_headers.csv,instacart_2017_05_01/order_products__prior.csv,instacart_2017_05_01/order_products__train.csv" \
	--relationships:ITEM "order_products_products_headers.csv,instacart_2017_05_01/order_products__prior.csv,instacart_2017_05_01/order_products__train.csv"

$(NEO4J_DATA_DIR)/instacart.db: $(TARGETS)
	$(NEO4J_ADMIN) import \
	--database instacart.db \
	--id-type string \
	--ignore-duplicate-nodes true \
	--nodes:User "users_headers.csv,instacart_2017_05_01/orders.csv" \
	--nodes:Aisle "aisles_headers.csv,instacart_2017_05_01/aisles.csv" \
	--nodes:Department "departments_headers.csv,instacart_2017_05_01/departments.csv" \
	--nodes:Product "products_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--nodes:Order "orders_headers.csv,instacart_2017_05_01/orders.csv" \
	--nodes:OrderedItem "order_products_headers.csv,instacart_2017_05_01/order_products__train.csv" \
	--relationships:ON "products_aisles_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--relationships:IN "products_departments_headers.csv,instacart_2017_05_01/products.scrubbed.csv" \
	--relationships:ORDERED "users_orders_headers.csv,instacart_2017_05_01/orders.csv" \
	--relationships:IN_ORDER "order_products_order_headers.csv,instacart_2017_05_01/order_products__train.csv" \
	--relationships:ITEM "order_products_products_headers.csv,instacart_2017_05_01/order_products__train.csv"

instacart_2017_05_01/%.csv: $(INSTA_DATA)
	tar -xzf $< $@ &&\
	sed -i 1d $@

instacart_2017_05_01/products.scrubbed.csv: instacart_2017_05_01/products.csv
	sed 's/\""/\"/g' $< > $@

clean:
	if [ -e instacart_2017_05_01/ ]; then rm -rf instacart_2017_05_01/; fi && \
	if [ -e $(NEO4J_DATA_DIR)/instacart.db ]; then rm -r $(NEO4J_DATA_DIR)/instacart.db; fi && \
  if [ -e $(NEO4J_DATA_DIR)/instacart.full.db ]; then rm -r $(NEO4J_DATA_DIR)/instacart.full.db; fi