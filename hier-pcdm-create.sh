#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/hierpcdm > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-member.ru $FEDORA_BASE/hierpcdm/m/ > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-member.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/ > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/ > /dev/null

	# Establish the files
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/ > /dev/null
	curl -is -X PUT $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/data-file/fcr:metadata > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/ > /dev/null
	curl -is -X PUT $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/data-file/fcr:metadata > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS hierpcdm: $TOTAL"
export PERF_RESULT_TIME=$TOTAL