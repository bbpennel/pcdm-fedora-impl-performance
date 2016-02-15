#!/usr/bin/env bash

curl -is -X PUT $FEDORA_BASE/mnoldp/dest > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-5000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: $FEDORA_BASE/mnoldp/dest/obj$COUNT" $FEDORA_BASE/mnoldp/obj$COUNT > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS min-mnoldp: $TOTAL"
