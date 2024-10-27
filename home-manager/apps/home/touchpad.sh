#!/bin/sh

SEARCH="Touchpad"

if [ "$SEARCH" = "" ]; then 
    exit 1
fi

ids=$(xinput --list | awk -v search="$SEARCH" \
    '$0 ~ search {match($0, /id=[0-9]+/);\
                  if (RSTART) \
                    print substr($0, RSTART+3, RLENGTH-3)\
                 }'\
     )

for i in $ids
do
    # echo "Touch pad found, device : $i"
    if [ "$1" == "1" ]; then
        echo "Enabling Touchpad device [$i]"
        xinput enable $i
    else
        echo "Disabling Touchpad device [$i]"
        xinput disable $i
    fi
    #xinput set-prop $i 'Device Accel Profile' -1
    #xinput set-prop $i 'Device Accel Constant Deceleration' 2.5
    #xinput set-prop $i 'Device Accel Velocity Scaling' 1.0
done
