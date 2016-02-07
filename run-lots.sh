DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

NUM_OBJS=1000
NUM_RUNS=3

echo "##########################no-pcdm###########################"

COUNTER=0
while [ $COUNTER -lt $NUM_RUNS ]; do
	$DIR/no-pcdm-create.sh
	$DIR/no-pcdm-move.sh
	$DIR/no-pcdm-delete.sh
	$COUNTER=$COUNTER + 1
done

echo "##########################no-ldp###########################"

COUNTER=0
while [ $COUNTER -lt $NUM_RUNS ]; do
	$DIR/no-ldp-pcdm-create.sh
	$DIR/no-ldp-pcdm-move.sh
	$DIR/no-ldp-pcdm-delete.sh
	$COUNTER=$COUNTER + 1
done

echo "###########################flat-pcdm##########################"

COUNTER=0
while [ $COUNTER -lt $NUM_RUNS ]; do
	$DIR/flat-pcdm-create.sh
	$DIR/flat-pcdm-move.sh
	$DIR/flat-pcdm-delete.sh
	$COUNTER=$COUNTER + 1
done

echo "###########################hier-pcdm##########################"

COUNTER=0
while [ $COUNTER -lt $NUM_RUNS ]; do
	$DIR/hier-pcdm-create.sh
	$DIR/hier-pcdm-move.sh
	$DIR/hier-pcdm-delete.sh
	$COUNTER=$COUNTER + 1
done