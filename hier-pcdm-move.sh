#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/hierpcdm/m/dest > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-member.ru $FEDORA_BASE/hierpcdm/m/dest/m/ > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: $FEDORA_BASE/hierpcdm/m/dest/m/obj$COUNT" $FEDORA_BASE/hierpcdm/m/obj$COUNT > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS hierpcdm: $TOTAL"
export PERF_RESULT_TIME=$TOTAL