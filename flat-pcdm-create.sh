#!/usr/bin/env bash
vagrant ssh -c "sudo /etc/init.d/tomcat7 stop"
vagrant ssh -c "sudo rm -r /var/lib/tomcat7/fcrepo4-data/*"
vagrant ssh -c "sudo /etc/init.d/tomcat7 start"

curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdm > /dev/null
curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdm/members/ > /dev/null
curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-indirect-to-parent.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/members/ > /dev/null

	# Attach proxy to add aggregate to collection
	echo "
	@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/obj$COUNT/> ;
	   ore:proxyIn </fcrepo/rest/flatpcdm/> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/flatpcdm/members/objProxy$COUNT > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file0_$COUNT/ > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file1_$COUNT/ > /dev/null

	# Create the proxies for individual objects
	echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/file0_$COUNT/> ;
	   ore:proxyIn  </fcrepo/rest/flatpcdmobjects/obj$COUNT> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/members/file0Proxy > /dev/null
	echo "@prefix ore: <http://www.openarchives.org/ore/terms/>
	<> ore:proxyFor </fcrepo/rest/flatpcdmobjects/file1_$COUNT/> ;
	   ore:proxyIn  </fcrepo/rest/flatpcdmobjects/obj$COUNT> .
	" | curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @- 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/obj$COUNT/members/file1Proxy > /dev/null


	# Establish the files
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file0_$COUNT/files/ > /dev/null
	curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @cover.jpg 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file0_$COUNT/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file0_$COUNT/files/data-file/fcr:metadata > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @direct-has-file.ru 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file1_$COUNT/files/	 > /dev/null
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file1_$COUNT/files/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/flatpcdmobjects/file1_$COUNT/files/data-file/fcr:metadata > /dev/null
	
	echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS flatpcdm: $TOTAL"

sleep 1800
curl -si -X POST "http://localhost:8080/fuseki/test/query" --header "Content-Type: application/sparql-query" --data-binary "SELECT count(*) WHERE {  ?subject ?predicate ?object . FILTER (regex(STR(?subject), 'fcrepo/rest')) }"