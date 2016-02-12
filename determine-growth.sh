DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export WAIT_BEFORE_QUERY=45

declare -a impls=("no-pcdm" "no-ldp-pcdm" "hier-pcdm" "flat-pcdm")

for impl in "${impls[@]}"
do
    echo "##########################$impl###########################"
    
    for (( i=1; i<=2; i++ ))
    do
        $DIR/restart-tomcat.sh
        
        export NUM_OBJS=$i
        $DIR/$impl-create.sh
        $DIR/counts.sh
        
        sleep 30
    done
done