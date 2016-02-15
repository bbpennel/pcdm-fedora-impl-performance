#!/bin/bash
# Runs all of the listed impls, performing create, move, and delete for NUM_OBJS objects.
# Repeats each test NUM_RUNS times.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export BASE_URL="http://127.0.0.1:8080"
export FEDORA_BASE="$BASE_URL/fcrepo/rest"

# Number of high level objects to test with
export NUM_OBJS=200
# Number of executions of each test to perform
NUM_RUNS=25

# List of tests to run
declare -a impls=("no-pcdm" "no-ldp-pcdm" "min-no-ldp-pcdm" "hier-pcdm" "flat-pcdm")

for impl in "${impls[@]}"
do
    echo "##########################$impl###########################"
    $DIR/restart-tomcat.sh
    CREATE_TOTAL=0
    MOVE_TOTAL=0

    for (( i=0; i<$NUM_RUNS; i++ ))
    do
 		export START_COUNT=$((i * NUM_RUNS))
        $DIR/$impl-create.sh
        $DIR/$impl-move.sh
    done
done