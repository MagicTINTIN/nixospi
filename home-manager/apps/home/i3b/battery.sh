#!/usr/bin/env bash
str=$(acpi -b)
# BAT=$(acpi -b | grep -E -o '[0-9][0-9]?[0-9]?%' | head -n 1)
BAT=$(echo $str | grep -E -o '[0-9][0-9]?[0-9]?%' | head -n 1)

# Full and short texts
# echo "Battery: $BAT"
# echo "🗲🗱 $BAT"
if [[ $str == *"Discharging"* ]]; then
    echo "🗱 $BAT"
    echo "🗱 $BAT"
else
    echo "🗲 $BAT"
    echo "🗲 $BAT"
fi

if [ ${BAT%?} -eq 69 ]; then
    echo "#FF99FF"
fi
if [ ${BAT%?} -le 50 || $BAT ]; then
    echo "#FFF000"
fi
if [ ${BAT%?} -le 20 ]; then
    exit 33
fi

# Set urgent flag below 20% or use orange below 50%
# [ ${BAT%?} -le 20 ] && exit 33
# [ ${BAT%?} -le 90 ] && echo "#FF8000"

exit 0