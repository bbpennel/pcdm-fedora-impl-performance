#!/bin/bash
# Runs all of the listed impls, performing create, move, and delete for NUM_OBJS objects.
# Repeats each test NUM_RUNS times.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export BASE_URL="http://127.0.0.1:8080"
export FEDORA_BASE="$BASE_URL/fcrepo/rest"

# Number of high level objects to test with
export NUM_OBJS=1000
# Number of executions of each test to perform
NUM_RUNS=3

# List of tests to run
declare -a impls=("no-pcdm" "no-ldp-pcdm" "min-no-ldp-pcdm" "hier-pcdm" "flat-pcdm")

for impl in "${impls[@]}"
do
    echo "##########################$impl###########################"

    for (( i=1; i<=$NUM_RUNS; i++ ))
    do
        $DIR/restart-tomcat.sh

        $DIR/$impl-create.sh
        $DIR/$impl-traverse.sh
        $DIR/$impl-move.sh
        $DIR/$impl-delete.sh

        sleep 30
    done
done