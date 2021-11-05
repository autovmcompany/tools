#!/bin/sh

# MONITOR BANDWIDTH
function bandwidth {

    # FIND MACHINES
    esxcli network vm list | while read first; do

        # FIND WORLD
        world=$(echo $first | cut -d ' ' -f1)

        # FIND NAME
        name=$(echo $first | cut -d ' ' -f2)

        # FIND DATA
        data=$(esxcli network vm port list -w $world | head -n 1 | grep -Eo [0-9]+ | xargs esxcli network port stats get -p | grep Bytes | grep -Eo [0-9]+)

        # FIND RECIEVED
        recieved=$(echo $data | cut -d ' ' -f1 | grep -Eo [0-9]+)

        # FIND SENT
        sent=$(echo $data | cut -d ' ' -f2 | grep -Eo [0-9]+)

        # VALIDATE DATA
        if test $recieved; then

            # SEND REQUEST
            wget -O bandwidth $1/$name/$recieved/$sent --header "token:$2"
        fi
    done
}

# INFINITE LOOP
while true; do

    # MONITOR BANDWIDTH
    bandwidth $1 $2

    # DELAY FOR LOOP
    sleep 60
done
