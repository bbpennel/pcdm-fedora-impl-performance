#!/usr/bin/env bash

curl -is -X PUT $FEDORA_BASE/nopcdm/dest > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: $FEDORA_BASE/nopcdm/dest/obj$COUNT" $FEDORA_BASE/nopcdm/obj$COUNT > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS nopcdm: $TOTAL"
export PERF_RESULT_TIME=$TOTAL