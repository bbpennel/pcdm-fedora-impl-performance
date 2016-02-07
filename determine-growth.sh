DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WAIT_BEFORE_QUERY=300

echo "##########################no-pcdm###########################"

NUM_OBJS=1
$DIR/no-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=2
$DIR/no-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=3
$DIR/no-pcdm-create.sh
$DIR/counts.sh


echo "##########################no-ldp###########################"

NUM_OBJS=1
$DIR/no-ldp-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=2
$DIR/no-ldp-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=3
$DIR/no-ldp-pcdm-create.sh
$DIR/counts.sh


echo "###########################flat-pcdm##########################"

NUM_OBJS=1
$DIR/flat-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=2
$DIR/flat-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=3
$DIR/flat-pcdm-create.sh
$DIR/counts.sh

echo "###########################hier-pcdm##########################"

NUM_OBJS=1
$DIR/hier-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=2
$DIR/hier-pcdm-create.sh
$DIR/counts.sh
NUM_OBJS=3
$DIR/hier-pcdm-create.sh
$DIR/counts.sh