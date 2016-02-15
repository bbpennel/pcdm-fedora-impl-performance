#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/mnoldp > /dev/null
curl -is -X DELETE $FEDORA_BASE/mnoldp/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "MIN-NO-LDP	DELETE	0	$NUM_OBJS	$TOTAL"