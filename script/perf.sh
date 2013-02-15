#!/bin/sh

XENTOP=/usr/sbin/xentop
PERF_LOG_FILE=`pwd`/perf.log

$XENTOP -b -i 1 > $PERF_LOG_FILE

N=`wc -l $PERF_LOG_FILE | awk '{print $1}'`

INSTANCES=`tail $PERF_LOG_FILE -n $(expr $N - 1)`
LINES=(`echo $INSTANCES | sed -e 's/ /,/g'`)

while read LINE; do
        if [ "${LINE:0:4}" == "NAME" ]; then
                echo NAME,CPU_IDLE,NETWORK_INPUT,NETWORK_OUTPUT,DISK_READ,DISK_WRITE
                continue
        fi

        NAME=`echo $LINE | awk '{print $1}'`
        CPU_IDLE=`echo $LINE | awk '{print $4}'`
        NETWORK_INPUT=`echo $LINE | awk '{print $11}'`
        NETWORK_OUTPUT=`echo $LINE | awk '{print $12}'`
        DISK_READ=`echo $LINE | awk '{print $17}'`
        DISK_WRITE=`echo $LINE | awk '{print $18}'`

        #echo $LINE
        echo $NAME,$CPU_IDLE,$NETWORK_INPUT,$NETWORK_OUTPUT,$DISK_READ,$DISK_WRITE
done < $PERF_LOG_FILE
