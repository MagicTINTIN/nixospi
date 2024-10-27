#!/usr/bin/env bash
NUM_OF_CPU=$(grep -c ^processor /proc/cpuinfo)
CPUsIdling=$(mpstat 1 1 -P ALL --dec=0 | tail -n $NUM_OF_CPU  | awk '{print $12}')

total=0
for val in $CPUsIdling
do
    #echo -ne "$val"
    total=$(($total+100-$val))
    if [[ $val -gt 87 ]]; then
        echo -ne "▁"
    elif [[ $val -gt 75 ]]; then
        echo -ne "▂"
    elif [[ $val -gt 62 ]]; then
        echo -ne "▃"
    elif [[ $val -gt 50 ]]; then
        echo -ne "▄"
    elif [[ $val -gt 37 ]]; then
        echo -ne "<span color=\"yellow\">▅</span>"
    elif [[ $val -gt 25 ]]; then
        echo -ne "<span color=\"yellow\">▆</span>"
    elif [[ $val -gt 12 ]]; then
        echo -ne "<span color=\"orange\">▇</span>"
    else
        echo -ne "<span color=\"red\">█</span>"
    fi
done
total=$(($total/$NUM_OF_CPU))
echo -ne "|🖾 $total%\n"
exit 0

# ▁▂▃▄▅▆▇█