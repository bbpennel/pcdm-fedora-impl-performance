#!/usr/bin/env bash

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/obj$COUNT/ > /dev/null
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/obj$COUNT/fcr:tombstone > /dev/null

	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/ > /dev/null
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/fcr:tombstone > /dev/null
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/ > /dev/null
	curl -is -X DELETE $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/fcr:tombstone > /dev/null
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "FLAT-PCDM	DELETE	0	$NUM_OBJS	$TOTAL"