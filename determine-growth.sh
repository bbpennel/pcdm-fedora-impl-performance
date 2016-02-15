#!/bin/bash
# Used to determine the number of objects/triples per object with each implementation listed.
# Creates a minimal number of objects per impl, and then queries fuseki after a delay.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

export BASE_URL="http://127.0.0.1:8080"
export FEDORA_BASE="$BASE_URL/fcrepo/rest"
export WAIT_BEFORE_QUERY=45

declare -a impls=("no-pcdm" "no-ldp-pcdm" "hier-pcdm" "flat-pcdm")

for impl in "${impls[@]}"
do
    echo "##########################$impl###########################"
    
    for (( i=1; i<=3; i++ ))
    do
        $DIR/restart-tomcat.sh
        sleep 30
        
        export NUM_OBJS=$i
        $DIR/$impl-create.sh
        $DIR/counts.sh
    done
done