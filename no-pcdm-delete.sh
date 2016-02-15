#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/nopcdm > /dev/null
curl -is -X DELETE $FEDORA_BASE/nopcdm/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete $OBJECTS nopcdm: $TOTAL"
export PERF_RESULT_TIME=$TOTAL