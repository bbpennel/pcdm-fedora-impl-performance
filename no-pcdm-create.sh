#!/usr/bin/env bash
vagrant ssh -c "sudo /etc/init.d/tomcat7 stop" > /dev/null 2> /dev/null
vagrant ssh -c "sudo rm -r /var/lib/tomcat7/fcrepo4-data/*" > /dev/null 2> /dev/null
vagrant ssh -c "sudo /etc/init.d/tomcat7 start" > /dev/null 2> /dev/null

curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm > /dev/null

START=`date +%s`

COUNT=0
OBJECTS=${NUM_OBJS:-1000}
while [ $COUNT -lt $OBJECTS ]; do
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT > /dev/null

	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file0 > /dev/null
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file1 > /dev/null
	
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file0/data-file > /dev/null
	curl -is -X PUT 127.0.0.1:8080/fcrepo/rest/nopcdm/obj$COUNT/file1/data-file > /dev/null
	
	#echo "$COUNT"
	
	COUNT=$(( COUNT + 1 ))
done

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to create $OBJECTS nopcdm: $TOTAL"