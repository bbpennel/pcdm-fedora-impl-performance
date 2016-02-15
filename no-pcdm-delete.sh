#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/nopcdm > /dev/null
curl -is -X DELETE $FEDORA_BASE/nopcdm/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "NO-PCDM	DELETE	0	$NUM_OBJS	$TOTAL"