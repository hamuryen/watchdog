#!/bin/bash

#applicaiton directory
cd /opt/app/

#start, stop or status
command=$1
while true
 do	
	#kill other services
	other_service_pid=$(pgrep app.service)
    current_service_pid=$$
	for service_pid in $other_service_pid
	do
		if [ "$current_service_pid" -ne "$service_pid" ];	then
		    kill -9 $service_pid
		fi
	done

	
	app_pid=$(pgrep app.exe) #get already running apps
	if [ "$command" = "start" ]; then #start
		number_of_p=$($app_pid | wc -l)
		if [ "$number_of_p" = "0" ]; then #no running app
			command="run";			
		else
			echo "already running"		
		fi		
	elif [ "$command" = "stop" ]; then #stop
		for a in $app_pid
		do
		   	 kill -9 $a
		done
		exit
	elif [ "$command" = "status" ]; then #status
		number_of_p=$($app_pid | wc -l) #get number of running apps
		if [ "$number_of_p" = "0" ]; then #if currently running app count is 0 then exit from script
			echo "not running"
			exit
		fi
		for a in $app_pid #write to terminal currently running apps pids
		do
		   	echo  "running pid: $a"
			command="run";
		done	
	fi
	
	if [ "$command" = "run" ]; then #run
		number_of_p=$($app_pid | wc -l) #get number of running apps
		if [ "$number_of_p" = "0" ]; then #if currently running app count is 0 then run a new app
			echo "running app"
			./app.exet &
		fi
	fi

	command="run";	
   	sleep 1
done
