# default vars
NUM_POM=2
POM_LENGTH=25
BREAK_LENGTH=5
LOG_POMODORO=


#======================
# convenient functions
#======================
function usage(){
cat << EOF
    usage $0 options:
    OPTIONS:
    -h    show this message
    -n    total Number of pomodori you want to run. Default is 2 pomodori
    -p    Pomodoro length (in minutes) of each pomodoro. Default is 25 minutes
    -b    Break length (in minutes). Default is 5 minutes
    -l    Log file path. Default is ~/pomshell.log
EOF
}

function start_program(){
    now=$(date +"%d/%m/%Y %T")
    echo "========================================="
    echo "====== Start at $now ====="
    echo "========================================="
    echo "Run $NUM_POM pomodori with length $POM_LENGTH minutes each, break: $BREAK_LENGTH minutes each"
}

function end_program(){
    finished_time=$(date +"%T")
    echo "========================================="
    echo "=========== Finished $finished_time ==========="
    echo "========================================="
}

function pomodoro_start(){
    local pom_count=$1
    echo "$pom_count start"
    notify-send  "Start $pom_count -- length $POM_LENGTH minutes"
    sleep $pom_length_in_seconds
    echo  "$pom_count end"
}

function break_start(){
    local break_count=$1
    echo "$break_count start"
    notify-send break "Break $BREAK_LENGTH minutes to the next pomodoro" -t $break_length_in_millisec
    sleep $break_length_in_seconds
    echo "$break_count end"
}



#=======================
# Get the run time args
#=======================
while getopts “hn:p:b:l:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         n)
             NUM_POM=$OPTARG
             ;;
         p)
             POM_LENGTH=$OPTARG
             ;;
         b)
             BREAK_LENGTH=$OPTARG
             ;;
         l)
             LOG_POMODORO=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if ( [[ -z $NUM_POM ]] || [[ -z $BREAK_LENGTH ]] || [[ -z $POM_LENGTH ]] ) ; then
     usage
     exit 1
fi


#==========================
# Main program starts here
#==========================

# convert minute to seconds and millisec
pom_length_in_seconds=$(( 60 * $POM_LENGTH ))
break_length_in_seconds=$(( 60 * $BREAK_LENGTH ))
break_length_in_millisec=$(( 3600 * $BREAK_LENGTH ))

start_program

current_pom=1
while [ $current_pom -le $NUM_POM ]
do
    pom_count="Pomodoro $current_pom"
    break_count="break $current_pom"

    pomodoro_start "$pom_count"

    if [ $current_pom -eq $NUM_POM ] ; then
        end_program
        exit
    else
        break_start "$break_count"
    fi

	(( current_pom++ ))

done

