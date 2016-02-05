#!/usr/bin/env bash
vagrant ssh -c "sudo /etc/init.d/tomcat7 stop"
vagrant ssh -c "sudo rm -r /var/lib/tomcat7/fcrepo4-data/*"
vagrant ssh -c "sudo /etc/init.d/tomcat7 start"

curl -is -X PUT  -H "Content-Type: text/turtle" --data-binary @pcdm-collection.ttl 127.0.0.1:8080/fcrepo/rest/noldp > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=1000
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT> .
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp > /dev/null

	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0 > /dev/null
	curl -is -X PUT -H "Content-Type: text/turtle" --data-binary @pcdm-object.ttl 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1 > /dev/null
	
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0> . 
		<> pcdm:hasMember <http://127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1> 
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT > /dev/null
	
	curl -is -X PUT -H "Content-Type: image/jpeg" --data-binary @page0.jpg 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0/data-file/fcr:metadata > /dev/null
	echo "PREFIX pcdm: <http://pcdm.org/models#> 
	INSERT { 
		<> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0/data-file> 
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file0 > /dev/null
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1/data-file > /dev/null
	curl -is -X PATCH -H "Content-Type: application/sparql-update" --data-binary @original-file.ru 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1/data-file/fcr:metadata > /dev/null
	echo "PREFIX pcdm: <http://pcdm.org/models#>
	INSERT {
		<> pcdm:hasFile <http://127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1/data-file>
	} WHERE {}
	" | curl -is -X PATCH -H "Content-Type:application/sparql-update" --data-binary @- 127.0.0.1:8080/fcrepo/rest/noldp/obj$COUNT/file1 > /dev/null
	
	echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS noldp: $TOTAL"

sleep 1800
curl -si -X POST "http://localhost:8080/fuseki/test/query" --header "Content-Type: application/sparql-query" --data-binary "SELECT count(*) WHERE {  ?subject ?predicate ?object . FILTER (regex(STR(?subject), 'fcrepo/rest')) }"