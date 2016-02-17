#!/usr/bin/env bash

traverse () {
  member_arr=($(curl -si -H "Accept: application/n-triples"  $1 | grep "hasMember\|hasFile" | sed 's/.*hasMember.*\<\([^\>]*\)\>\.* ./\1/g' | sed 's/.*hasFile.*\<\([^\>]*\)\>\.* ./\1/g'))
  
  for child in ${member_arr[@]}
  do
    traverse $child
  done
}

START=`date +%s`
traverse "$FEDORA_BASE/flatpcdm"

END=`date +%s`
TOTAL=$(( $END - $START ))

echo "FLAT-PCDM	TRAVERSE	0	$NUM_OBJS	$TOTAL"