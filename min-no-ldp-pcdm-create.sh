#!/usr/bin/env bash

curl -is -X PUT  -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/mnoldp > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file0 > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file0/data-file > /dev/null
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file1/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT/file1/data-file > /dev/null
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS min-mnoldp: $TOTAL"