#!/bin/bash
#
# Author: Lorenzo Padovani
# @padosoft
# https://github.com/lopadova
# https://github.com/padosoft
# Depending on your 'top' version and OS you might have
# to change head and tail line-numbers
#

#process command name to check
declare -a KILLLIST
KILLLIST=("/usr/sbin/apache2" "/usr/bin/php5-cgi")
#email (if empty no email will sent)
EMAIL="helpdesk@padosoft.com"
#max cpu % load
MAX_CPU=90
#max execution time for CPU percentage > MAX_CPU (in seconds 7200s=2h)
MAX_SEC=1800
#max execution time for any %CPU (in seconds 2700s=45min)
MAX_SEC2=2700
#exclude root process (leave empty for match root process too)
EXCLUDE_ROOT="grep -v root"
#colors
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
NC=`tput sgr0` # No Color
#set screen width
#if you command (specially if executed in cron) truncate columns to 80 less chars
#and your line is too long, set the right columns number here.
#leave empty string "" for default columns environment.
COLSNUM=""

#
# PARSE ARGUMENTS
#

#print command signature and usage
if [ "$1" = "" ] || [ "$1" = "--help" ] || [ $# -lt 1 ] || [ $# -gt 3 ]; then
    printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n' \
        "USAGE: bash $0 [dry|kill|--help] [top|ps] [cpu|time]" \
        "Example:" \
        "bash $0 dry" \
        "bash $0 dry top" \
        "bash $0 kill top cpu" \
        "For help:" \
        "bash $0" \
        "OR" \
        "bash $0 --help" >&2
    exit 0
fi

#check if needed to set columns
if [ "$COLSNUM" = "" ]; then    
    echo "process use default environment columns number."
else
    echo "process set '${YELLOW}${COLSNUM}${NC}' columns number."        
fi

#kill or not kill?
if [ "$1" = "kill" ]; then
    KILL=1
    echo "${RED}Process execute in 'kill' mode.${NC}"
else
    KILL=0
    echo "Process execute in '${YELLOW}dry${NC}' mode (no kill)."
fi

#command to retrive process
if [ "$2" = "ps" ]; then
    CMD="ps"
    echo "Process fetched by '${YELLOW}ps${NC}' command"
elif [ "$2" = "top" ]; then
    CMD="top"
    echo "Process fetched by '${YELLOW}top${NC}' command"
else
    CMD="top"
    echo "Process fetched by '${YELLOW}top${NC}' command"
fi

#process Sort by
SORTBYN=""
if [ "$3" = "cpu" ]; then
    if [ "$CMD" = "ps" ]; then
        SORTBY=2
    else
        SORTBY=9
    fi
    echo "Process sort by ${YELLOW}%CPU${NC} ( $SORTBY )"
elif [ "$3" = "time" ]; then
    if [ "$CMD" = "ps" ]; then
        SORTBY=3
    else
        SORTBY=11
        SORTBYN="-n"
    fi
    echo "Process sort by ${YELLOW}TIME${NC} ( $SORTBY $SORTBYN)"
else
    if [ "$CMD" = "ps" ]; then
        SORTBY=2
    else
        SORTBY=9
    fi
    echo "Process sort by default ${YELLOW}CPU${NC} ( $SORTBY )"
fi


#iterate for each process to check in list
for PROCESS_TOCHECK in ${KILLLIST[*]}
do
    echo "Check ${YELLOW}$PROCESS_TOCHECK${NC} process..."

    #pid
    if [ "$CMD" = "ps" ]; then
      if [ "$COLSNUM" = "" ]; then    
        PID=$(ps -eo pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $1}')
      else
        PID=$(ps --cols ${COLSNUM} -eo pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $1}')
      fi
    else
      if [ "$COLSNUM" = "" ]; then    
        PID=$(top -bcSH -n 1 | $EXCLUDE_ROOT  | grep $PROCESS_TOCHECK | sort $SORTBYN -k $SORTBY -r | head -n 1 | awk '{print $1}')
      else
        PID=$(COLUMNS=${COLSNUM} top -bcSH -n 1 | $EXCLUDE_ROOT  | grep $PROCESS_TOCHECK | sort $SORTBYN -k $SORTBY -r | head -n 1 | awk '{print $1}')
      fi
    fi

    if [ -z "$PID" ]; then
        echo "${GREEN}There isn't any matched process for $PROCESS_TOCHECK${NC}"
        continue
    fi

    #Fetch other process stats by pid
    #% CPU
    if [ "$CMD" = "ps" ]; then
      if [ "$COLSNUM" = "" ]; then    
        CPU=$(ps -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $2}')
      else
        CPU=$(ps --cols ${COLSNUM} -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $2}')
      fi
    else
      if [ "$COLSNUM" = "" ]; then    
        CPU=$(top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $9}')
      else
        CPU=$(COLUMNS=${COLSNUM} top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $9}')
      fi    
    fi

    #format integer cpu
    CPU=${CPU%%.*}

    #time elapsed d-HH:MM:ss
    if [ "$CMD" = "ps" ]; then
      if [ "$COLSNUM" = "" ]; then    
        TIME_STR=$(ps ${COLSNUM} -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $3}')
      else
        TIME_STR=$(ps --cols ${COLSNUM} -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $3}')
      fi
    else
      if [ "$COLSNUM" = "" ]; then    
        TIME_STR=$(top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $11}') 
      else
        TIME_STR=$(COLUMNS=${COLSNUM} top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $11}')
      fi
    fi

    #process name
    if [ "$COLSNUM" = "" ]; then  
        PNAME=$(ps -p $PID -o pid,pcpu,time,comm,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
    else
        PNAME=$(ps --cols ${COLSNUM} -p $PID -o pid,pcpu,time,comm,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
    fi

    #full process command
    if [ "$CMD" = "ps" ]; then
      if [ "$COLSNUM" = "" ]; then    
        COMMAND=$(ps -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
      else
        COMMAND=$(ps --cols ${COLSNUM} -p $PID -o pid,pcpu,time,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
      fi
    else
      if [ "$COLSNUM" = "" ]; then    
        COMMAND=$(top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $12,$13,$14}')
      else
        COMMAND=$(COLUMNS=${COLSNUM} top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $12,$13,$14}')
      fi
    fi


    #user
    if [ "$CMD" = "ps" ]; then
      if [ "$COLSNUM" = "" ]; then    
        USER=$(ps -p $PID -o pid,pcpu,time,user,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
      else
        USER=$(ps --cols ${COLSNUM} -p $PID -o pid,pcpu,time,user,command | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $4}')
      fi
    else
      if [ "$COLSNUM" = "" ]; then    
        USER=$(top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $2}')
      else
        USER=$(COLUMNS=${COLSNUM} top -p $PID -bcSH -n 1 | $EXCLUDE_ROOT | grep $PROCESS_TOCHECK | sort -k $SORTBY -r | head -n 1 | awk '{print $2}')
      fi
    fi

    # Decode the CPU time format [dd-]hh:mm:ss.
    TIME_SEC=0
    IFS="-:" read c1 c2 c3 c4 <<< "$TIME_STR"

    #with top command time format is hh:mm.ss, so truncare seconds in c2
    c2=${c2%%.*}

    if [ -n "$c4" ]
    then
      TIME_SEC=$((10#$c4+60*(10#$c3+60*(10#$c2+24*10#$c1))))
    elif [ -n "$c3" ]
    then
      if [ "$CMD" = "ps" ]; then
        TIME_SEC=$((10#$c3+60*(10#$c2+60*10#$c1)))
      else
        TIME_SEC=$(((10#$c3*24)*60*60)+60*(10#$c2+60*10#$c1))             
      fi   
    else
      if [ "$CMD" = "ps" ]; then
        TIME_SEC=$((10#0+(10#$c2+60*10#$c1)))
      else
        TIME_SEC=$((10#0+60*(10#$c2+60*10#$c1)))
      fi
    fi

    #process summary
    if [ "$3" = "time" ]; then
        echo "${YELLOW}TOP Long Time $PROCESS_TOCHECK process is:${NC}"
    else
        echo "${YELLOW}TOP %CPU consuming $PROCESS_TOCHECK process is:${NC}"
    fi
    echo "c1:$c1"
    echo "c2:$c2"
    echo "c3:$c3"
    echo "c4:$c4"
    echo "PID:$PID"
    echo "PNAME:$PNAME"
    echo "CPU:$CPU"
    echo "TIME_STR:$TIME_STR"
    echo "TIME_SEC:$TIME_SEC"
    echo "USER:$USER"
    echo "COMMAND:$COMMAND"

    #if user process is root, skip it
    if [ "$USER" = "root" ]; then
        echo "this is a root process, skip it!"
        echo " "
        continue;
    fi

    #check if need to kill process
    if [ $CPU -gt $MAX_CPU ] && [ $TIME_SEC -gt $MAX_SEC ]; then

        echo "CPU load from process $PNAME ( PID: $PID ) User: $USER has reached ${CPU}% for $TIME_STR. Process was killed."
        if [ ! -z $EMAIL ]; then
            echo "Send Mail to $EMAIL"
            mail -s "WEB: CPU load from process $PNAME ( PID: $PID ) User: $USER has reached ${CPU}% for $TIME_STR. Process was killed." $EMAIL < .
        fi
        if [ "$KILL" = "1" ]; then
            echo "${RED}kill -15 $PID${NC}"
            kill -15 $PID
            sleep 3
            echo "kill -9 $PID"
            kill -9 $PID
            echo "kill zombies"
            kill -HUP $(ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }')
        fi

    elif [ $TIME_SEC -gt $MAX_SEC2 ]; then

        echo "WEB: The process $PNAME ( PID: $PID ) User: $USER has running too long for $TIME_STR"
        if [ ! -z $EMAIL ]; then
            echo "Send Mail to $EMAIL"
            mail -s "WEB: The process $PNAME ( PID: $PID ) User: $USER has running too long for $TIME_STR" $EMAIL < .
        fi
        if [ "$KILL" = "1" ]; then
            echo "${RED}kill -15 $PID${NC}"
            kill -15 $PID
            sleep 3
            echo "kill -9 $PID"
            kill -9 $PID
            echo "kill zombies"
            kill -HUP $(ps -A -ostat,ppid | grep -e '[zZ]'| awk '{ print $2 }')
        fi

    else

        echo "${GREEN}$PROCESS_TOCHECK it's OK!${NC}"

    fi

    echo " "
done
