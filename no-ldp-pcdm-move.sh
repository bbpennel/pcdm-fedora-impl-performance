#!/usr/bin/env bash

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/noldp/dest > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	
	echo "PREFIX pcdm: <http://pcdm.org/models#>
	DELETE { <> pcdm:hasMember </fcrepo/rest/noldp/obj$COUNT> } WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/noldp > /dev/null
	
	curl -is -X MOVE -H "Destination: $FEDORA_BASE/noldp/dest/obj$COUNT" $FEDORA_BASE/noldp/obj$COUNT > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> INSERT { <> pcdm:hasMember </fcrepo/rest/noldp/dest/obj$COUNT> } WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/noldp/dest > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS noldp: $TOTAL"
export PERF_RESULT_TIME=$TOTAL