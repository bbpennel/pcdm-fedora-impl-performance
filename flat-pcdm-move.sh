#!/usr/bin/env bash

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/members/

echo "
@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/dest/> ;
   ore:proxyIn </fcrepo/rest/flatpcdm/> .
" | curl -is -XPUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/flatpcdm/members/destProxy

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: http://127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/members/objProxy$COUNT" 127.0.0.1:8080/fcrepo/rest/flatpcdm/members/objProxy$COUNT > /dev/null
	echo "PREFIX ore: <http://www.openarchives.org/ore/terms/>
		DELETE {
		  <> ore:proxyIn </fcrepo/rest/flatpcdm/> .
		} INSERT {
		  <> ore:proxyIn </fcrepo/rest/flatpcdmobjects/dest/> .
		} WHERE {
	}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- http://127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/dest/members/objProxy$COUNT
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS flatpcdm: $TOTAL"
