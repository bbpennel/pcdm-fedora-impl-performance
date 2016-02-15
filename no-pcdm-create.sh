#!/usr/bin/env bash

curl -is -X PUT $FEDORA_BASE/nopcdm > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=${NUM_OBJS:-1000}
OBJECTS=$((OBJECTS + COUNT))
echo -n "NO-PCDM	CREATE	$COUNT	$OBJECTS	"
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT > /dev/null

	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file0 > /dev/null
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file1/data-file > /dev/null
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "$TOTAL"