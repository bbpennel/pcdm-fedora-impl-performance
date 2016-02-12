#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export NUM_OBJS=1
NUM_RUNS=2

declare -a impls=("no-pcdm" "no-ldp-pcdm" "min-no-ldp-pcdm" "hier-pcdm" "flat-pcdm")

for impl in "${impls[@]}"
do
    echo "##########################$impl###########################"

    for (( i=1; i<=$NUM_RUNS; i++ ))
    do
        $DIR/restart-tomcat.sh

        $DIR/$impl-create.sh
        $DIR/$impl-move.sh
        $DIR/$impl-delete.sh

        sleep 30
    done
done