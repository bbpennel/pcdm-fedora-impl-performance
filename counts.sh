sleep ${WAIT_BEFORE_QUERY:-1}
echo "Number of triples"
curl -si -X POST "http://127.0.0.1:8080/fuseki/test/query" --header "Content-Type: application/sparql-query" --data-binary "SELECT count(*) WHERE {  ?subject ?predicate ?object . FILTER (regex(STR(?subject), 'fcrepo/rest')) }" 2> /dev/null
echo "Number of objects"
curl -si -X POST "http://127.0.0.1:8080/fuseki/test/query" --header "Content-Type: application/sparql-query" --data-binary "SELECT count(*) WHERE {  ?subject ?predicate <http://fedora.info/definitions/v4/repository#Resource> }" 2> /dev/null