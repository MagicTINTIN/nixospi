if [[ $(date +%H) == $(date +%M) ]]; then
    if [[ $(date +%M) == $(date +%S) ]]; then
        echo -ne "<span size=\"large\">$(date +%Y-%m-%d) <span background=\"red\" color=\"white\">$(date +%T)</span></span>\n<span size=\"large\"><span background=\"red\" color=\"white\">$(date +%T)</span></span>\n"
    else
        echo -ne "<span size=\"large\">$(date +%Y-%m-%d) <span color=\"red\">$(date +%T)</span></span>\n<span size=\"large\"><span color=\"red\">$(date +%T)</span></span>\n"
    fi
else
    echo -ne "<span size=\"large\">$(date +%Y-%m-%d) $(date +%T)</span>\n<span size=\"large\">$(date +%T)</span>\n"
fi
