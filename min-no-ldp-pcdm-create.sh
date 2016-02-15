#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT  -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/mnoldp > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/mnoldp/obj$COUNT > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/mnoldp/obj$COUNT/file0 > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/mnoldp/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/mnoldp/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/mnoldp/obj$COUNT/file0/data-file > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/mnoldp/obj$COUNT/file1/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/mnoldp/obj$COUNT/file1/data-file > /dev/null
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS min-mnoldp: $TOTAL"
export PERF_RESULT_TIME=$TOTAL