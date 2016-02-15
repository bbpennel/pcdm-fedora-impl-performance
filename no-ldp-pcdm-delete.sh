#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/noldp > /dev/null
curl -is -X DELETE $FEDORA_BASE/noldp/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "NO-LDP	DELETE	0	$NUM_OBJS	$TOTAL"