#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/flatpcdm > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-indirect-to-parent.ttl $FEDORA_BASE/flatpcdm/members/ > /dev/null
curl -is -X PUT $FEDORA_BASE/flatpcdmobjects > /dev/null

START=`date +%s`

COUNT=${START_COUNT:-0}
OBJECTS=$(($COUNT + ${NUM_OBJS:-1000}))
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/flatpcdmobjects/obj$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-indirect-to-parent.ttl $FEDORA_BASE/flatpcdmobjects/obj$COUNT/members/ > /dev/null

	# Attach proxy to add aggregate to collection
	echo "
	@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/obj$COUNT/> ;
	   ore:proxyIn </fcrepo/rest/flatpcdm/> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- $FEDORA_BASE/flatpcdm/members/objProxy$COUNT > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/ > /dev/null

	# Create the proxies for individual objects
	echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/file0_$COUNT/> ;
	   ore:proxyIn  </fcrepo/rest/flatpcdmobjects/obj$COUNT> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- $FEDORA_BASE/flatpcdmobjects/obj$COUNT/members/file0Proxy > /dev/null
	echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/file1_$COUNT/> ;
	   ore:proxyIn  </fcrepo/rest/flatpcdmobjects/obj$COUNT> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- $FEDORA_BASE/flatpcdmobjects/obj$COUNT/members/file1Proxy > /dev/null


	# Establish the files
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-file.ru $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/files/ > /dev/null
	curl -is -X PUT $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru $FEDORA_BASE/flatpcdmobjects/file0_$COUNT/files/data-file/fcr:metadata > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/direct-has-file.ru $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/files/	 > /dev/null
	curl -is -X PUT $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru $FEDORA_BASE/flatpcdmobjects/file1_$COUNT/files/data-file/fcr:metadata > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS flatpcdm: $TOTAL"

export PERF_RESULT_TIME=$TOTAL