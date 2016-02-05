#!/usr/bin/env bash

curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/noldp/dest > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	echo "PREFIX pcdm: <http://pcdm.org/models#>
	DELETE { <> pcdm:hasMember </fcrepo/rest/noldp/obj$COUNT> } WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp > /dev/null
	
	curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/noldp/dest/obj$COUNT" 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasMember </fcrepo/rest/noldp/dest/obj$COUNT> } WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp/dest > /dev/null
	
	echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS noldp: $TOTAL"

sleep 10
curl -si -X POST "http://localhost:8080/fuseki/test/query" --header "Content-Type: application/sparql-query" --data-binary "SELECT count(*) WHERE {  ?subject ?predicate ?object . FILTER (regex(STR(?subject), 'fcrepo/rest')) }" 2> /dev/null