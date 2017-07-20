FROM neo4j

RUN mkdir -p /var/lib/instacart
COPY terms_conditions.md /var/lib/instacart/
COPY citation.md /var/lib/instacart/
COPY modified-entrypoint.sh /modified-entrypoint.sh

ENTRYPOINT ["/modified-entrypoint.sh"]
CMD ["neo4j"]
