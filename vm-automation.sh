#!/bin/bash

export VMS_DIR="~/VMs"
export LOCK_DIR="*.lck"
export LOG_FILE="/var/log/vm-service.log"

isVmUsed()
{
if [ -d $dir/$LOCK_DIR ]; then
  	return 1
else
		return 0
fi
}

startAll()
{
find "$VMS_DIR" -mindepth 1 -type f -name \*.vmx -print;
find "$VMS_DIR" -mindepth 1 -type f -name \*.vmx -exec bash -c 'start "$1"' _ {} \;
}

stopAll()
{
find "$VMS_DIR" -mindepth 1 -type f -name \*.vmx -print;
find "$VMS_DIR" -mindepth 1 -type f -name \*.vmx -exec bash -c 'stop "$1"' _ {} \;
}

#find $VMS_DIR/  -type f -depth 2 -name *.vmx

#find /home/g2mobility/VMs/ -mindepth 1 -type f -name \*.vmx -print

count()
{
 find $1 -mindepth 1 -type f -name \*.vmx -exec printf '.' \;| wc -c
}

start()
{
	touch ${LOG_FILE}
	VMX_FILE=$1
 	echo "Starting using file $VMX_FILE" >> "${LOG_FILE}"
        VMX_FILENAME=$(basename "$VMX_FILE")
        VMX_FILE_DIR=$(dirname "$VMX_FILE")
        echo "Filename - $VMX_FILENAME -" >> "${LOG_FILE}"
        echo "File dir - $VMX_FILE_DIR -" >> "${LOG_FILE}"

        if [ $(find "$VMX_FILE_DIR" -mindepth 1 -type f -name \*.lck -exec printf '.' \;| wc -c) != 0 ]
        then
                echo "VM in $dir appears to be in use ($VMX_FILE_DIR/$LOCK_DIR exists), checking for ${VMX_FILENAME}" >> "${LOG_FILE}"
        elif [ -f "$VMX_FILE" ]
        then
                echo "********   Starting $VMX_FILENAME" >> "${LOG_FILE}"
                vmrun start "$VMX_FILE"
                echo "********   Started $VMX_FILENAME" >> "${LOG_FILE}"
        else
                echo "No *.vmx file found in $VMX_FILE_DIR" >> "${LOG_FILE}"
        fi
}

stop()
{
        VMX_FILE=$1
        echo "Stopping using file $VMX_FILE" >> "${LOG_FILE}"
        VMX_FILENAME=$(basename "$VMX_FILE")
        VMX_FILE_DIR=$(dirname "$VMX_FILE")
        echo "Filename - $VMX_FILENAME -" >> "${LOG_FILE}"
        echo "File dir - $VMX_FILE_DIR -" >> "${LOG_FILE}"
	echo "Looking for lock file"

        if [ $(find "$VMX_FILE_DIR" -mindepth 1 -type f -name \*.lck -exec printf '.' \;| wc -c) != 0 ]
        then
                echo "VM in $VMX_FILE_DIR appears to be in use, trying to kill virtual machine" >> "${LOG_FILE}"
        	if [ -f "$VMX_FILE" ]
        	then
                	echo "********   Stopping $VMX_FILENAME" >> "${LOG_FILE}"
                	vmrun stop "$VMX_FILE" soft
        	else
                echo "No *.vmx file found in $VMX_FILE_DIR" >> "${LOG_FILE}"
       		fi
	else
		echo "The VM doesn't seem to be up, skipping shutdown" >> "${LOG_FILE}"
	fi
}

export -f stop
export -f start
export -f startAll
export -f stopAll

case "$1" in
  	startAll)
	startAll
	;;
	stopAll)
	stopAll
	;;
	start)
	start $( readlink -f "$( dirname "$2" )" )/$( basename "$2" )
	;;
	stop)
	stop $( readlink -f "$( dirname "$2" )" )/$( basename "$2" )
	;;
esac