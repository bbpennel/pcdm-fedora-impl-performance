#!/usr/bin/env bash

traverse () {
  member_arr=($(curl -si -H "Accept: application/n-triples"  $1 | grep "contains" | sed 's/.*contains.*\<\([^\>]*\)\>\.* ./\1/g'))
  
  for child in ${member_arr[@]}
  do
    traverse $child
  done
}

START=`date +%s`
traverse "$FEDORA_BASE/mnoldp"

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "MIN-NO-LDP	TRAVERSE	0	$NUM_OBJS	$TOTAL"