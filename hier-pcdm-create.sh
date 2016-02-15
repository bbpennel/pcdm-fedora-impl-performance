#!/usr/bin/env bash

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl $FEDORA_BASE/hierpcdm > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru $FEDORA_BASE/hierpcdm/m/ > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-member.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/ > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/ > /dev/null

	# Establish the files
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/ > /dev/null
	curl -is -X PUT $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file0/files/data-file/fcr:metadata > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/ > /dev/null
	curl -is -X PUT $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru $FEDORA_BASE/hierpcdm/m/obj$COUNT/m/file1/files/data-file/fcr:metadata > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS hierpcdm: $TOTAL"