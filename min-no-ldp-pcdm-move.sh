#!/usr/bin/env bash

curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/mnoldp/dest > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-5000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/mnoldp/dest/obj$COUNT" 127.0.0.1:8080/fcrepo/rest/mnoldp/obj$COUNT > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS min-mnoldp: $TOTAL"
