#!/usr/bin/env bash

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/ > /dev/null
	curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/fcr:tombstone > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/ > /dev/null
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/fcr:tombstone > /dev/null

curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdm > /dev/null
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/flatpcdm/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete $OBJECTS flatpcdm: $TOTAL"
