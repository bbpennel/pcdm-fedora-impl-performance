#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/noldp > /dev/null
curl -is -X DELETE $FEDORA_BASE/noldp/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete noldp: $TOTAL"
export PERF_RESULT_TIME=$TOTAL