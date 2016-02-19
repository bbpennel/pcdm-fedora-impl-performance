#!/usr/bin/env bash

BASE_URI="$FEDORA_BASE/hierpcdm"
if [-n $AFTER_MOVE]; then
	BASE_URI="$BASE_URI/dest/m"
fi

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X DELETE $BASE_URI/obj$COUNT/ > /dev/null
	curl -is -X DELETE $BASE_URI/obj$COUNT/fcr:tombstone > /dev/null
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "HIER-PCDM	DELETE	0	$NUM_OBJS	$TOTAL"