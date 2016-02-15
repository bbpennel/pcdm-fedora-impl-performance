#!/usr/bin/env bash

curl -is -X PUT $FEDORA_BASE/nopcdm > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT > /dev/null

	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file0 > /dev/null
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PUT $FEDORA_BASE/nopcdm/obj$COUNT/file1/data-file > /dev/null
	
	#echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS nopcdm: $TOTAL"