OUT_FILE="/home/cptbirdy/logs/cpumonit.log"
type="pcpu"
count=0

while true; do
    #echo "$(sensors)"
    res=`sensors | sed -rn 's/.*temp1:\s+.([0-9]+).*/\1/p'`

    # get PID of target process
    pid=`ps -ef --sort=-"$type" | sed -n 2p | awk '{ print $2 }'`


    if [ $res -ge 70 ]
    then
    count=$((count + 1))
    dt=$(date '+%m/%d/%Y %H:%M:%S')
    echo "$dt: $res C is high" 

    # sort by cpu
    #echo $(ps -ef --sort=-pcpu | sed -n 2p | awk '{ print $11 }')

    # sort by memory
    #echo $(ps -ef --sort=-pmem | sed -n 2p | awk '{ print $11 }')

    cpulimit -p $pid -l 50 

    fi
    

    # create kill scenario longer 
    if [ $count -ge 4 ]
    then
    
    pkill $pid
    count=0

    fi

    # threshold at 5 seconds sustain
    sleep 5s
done
