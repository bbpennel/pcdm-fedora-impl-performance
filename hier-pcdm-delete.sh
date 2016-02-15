#!/usr/bin/env bash
START=`date +%s`
curl -is -X DELETE $FEDORA_BASE/hierpcdm > /dev/null
curl -is -X DELETE $FEDORA_BASE/hierpcdm/fcr:tombstone > /dev/null

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "Total time to delete $OBJECTS hierpcdm: $TOTAL"