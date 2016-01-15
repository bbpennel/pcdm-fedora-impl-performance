#!/usr/bin/env bash
echo "====Cleaning up===="
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/nopcdm > /dev/null
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/nopcdm/fcr:tombstone > /dev/null

curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT > /dev/null

	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file0 > /dev/null
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file1/data-file > /dev/null
	
	echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS nopcdm: $TOTAL"