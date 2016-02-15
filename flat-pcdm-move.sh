#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-collection.ttl $FEDORA_BASE/flatpcdmobjects/dest/ > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @$DIR/pcdm-indirect-to-parent.ttl $FEDORA_BASE/flatpcdmobjects/dest/members/ > /dev/null

echo "
@prefix ore: <http://www.openarchives.org/ore/terms/>
<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/dest/> ;
   ore:proxyIn </fcrepo/rest/flatpcdm/> .
" | curl -is -XPUT -H "Content-Type: text/turtle" --data-binary @- $FEDORA_BASE/flatpcdm/members/destProxy > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X MOVE -H "Destination: $FEDORA_BASE/flatpcdmobjects/dest/members/objProxy$COUNT" $FEDORA_BASE/flatpcdm/members/objProxy$COUNT > /dev/null
	echo "PREFIX ore: <http://www.openarchives.org/ore/terms/>
		DELETE {
		  <> ore:proxyIn </fcrepo/rest/flatpcdm/> .
		} INSERT {
		  <> ore:proxyIn </fcrepo/rest/flatpcdmobjects/dest/> .
		} WHERE {
	}" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- $FEDORA_BASE/flatpcdmobjects/dest/members/objProxy$COUNT > /dev/null
	
	# echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to move $OBJECTS flatpcdm: $TOTAL"
