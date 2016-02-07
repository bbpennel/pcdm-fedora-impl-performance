DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "##########################no-pcdm###########################"

$DIR/no-pcdm-create.sh
$DIR/no-pcdm-move.sh
$DIR/no-pcdm-delete.sh
$DIR/no-pcdm-create.sh
$DIR/no-pcdm-move.sh
$DIR/no-pcdm-delete.sh
$DIR/no-pcdm-create.sh
$DIR/no-pcdm-move.sh
$DIR/no-pcdm-delete.sh

echo "##########################no-ldp###########################"



$DIR/no-ldp-pcdm-create.sh
$DIR/no-ldp-pcdm-move.sh
$DIR/no-ldp-pcdm-delete.sh
$DIR/no-ldp-pcdm-create.sh
$DIR/no-ldp-pcdm-move.sh
$DIR/no-ldp-pcdm-delete.sh
$DIR/no-ldp-pcdm-create.sh
$DIR/no-ldp-pcdm-move.sh
$DIR/no-ldp-pcdm-delete.sh

echo "###########################flat-pcdm##########################"

$DIR/flat-pcdm-create.sh
$DIR/flat-pcdm-move.sh
$DIR/flat-pcdm-delete.sh
$DIR/flat-pcdm-create.sh
$DIR/flat-pcdm-move.sh
$DIR/flat-pcdm-delete.sh
$DIR/flat-pcdm-create.sh
$DIR/flat-pcdm-move.sh
$DIR/flat-pcdm-delete.sh

echo "###########################hier-pcdm##########################"

$DIR/hier-pcdm-create.sh
$DIR/hier-pcdm-move.sh
$DIR/hier-pcdm-delete.sh
$DIR/hier-pcdm-create.sh
$DIR/hier-pcdm-move.sh
$DIR/hier-pcdm-delete.sh
$DIR/hier-pcdm-create.sh
$DIR/hier-pcdm-move.sh
$DIR/hier-pcdm-delete.sh