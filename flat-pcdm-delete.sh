#!/usr/bin/env bash

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/obj$COUNT/ > /dev/null
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/obj$COUNT/fcr:tombstone > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/dest/ > /dev/null
curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/dest/fcr:tombstone > /dev/null

curl -is -X DELETE $FEDORA_BASE/flatpcdm > /dev/null
curl -is -X DELETE $FEDORA_BASE/flatpcdm/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete $OBJECTS flatpcdm: $TOTAL"
