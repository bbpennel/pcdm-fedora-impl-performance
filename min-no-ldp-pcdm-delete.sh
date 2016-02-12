#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/mnoldp > /dev/null
curl -is -X DELETE 127.0.0.1:8080/fcrepo/rest/mnoldp/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete $OBJECTS mnoldp: $TOTAL"