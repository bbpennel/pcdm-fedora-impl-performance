#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT  -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/noldp > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/noldp/obj$COUNT > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasMember <$FEDORA_BASE/noldp/obj$COUNT> .
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/noldp > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/noldp/obj$COUNT/file0 > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-object.ttl $FEDORA_BASE/noldp/obj$COUNT/file1 > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasMember <$FEDORA_BASE/noldp/obj$COUNT/file0> . 
		<> pcdm:hasMember <$FEDORA_BASE/noldp/obj$COUNT/file1> 
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/noldp/obj$COUNT > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/noldp/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/noldp/obj$COUNT/file0/data-file > /dev/null
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasFile <$FEDORA_BASE/noldp/obj$COUNT/file0/data-file> 
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/noldp/obj$COUNT/file0 > /dev/null
	
	curl -is -X PUT $FEDORA_BASE/noldp/obj$COUNT/file1/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @$DIR/original-file.ru $FEDORA_BASE/noldp/obj$COUNT/file1/data-file > /dev/null
	echo "PREFIX pcdm: <http://pcdm.org/models#>
	INSERT {
		<> pcdm:hasFile <$FEDORA_BASE/noldp/obj$COUNT/file1/data-file>
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type:application/sparql-update" --data-binary @- $FEDORA_BASE/noldp/obj$COUNT/file1 > /dev/null
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS noldp: $TOTAL"