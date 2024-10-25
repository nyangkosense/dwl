#!/bin/bash

# Launch dwlb with JWR dark theme - all backgrounds set to terminal background color
launch_dwlb() {
    dwlb -ipc \
        -status-commands \
        -center-title \
        -font "PragmataPro:size=13" \
        -vertical-padding 4 \
        -active-fg-color "#C0C0C0" \
        -active-bg-color "#1A1A1A" \
        -occupied-fg-color "#899CA1" \
        -occupied-bg-color "#1A1A1A" \
        -inactive-fg-color "#3D3D3D" \
        -inactive-bg-color "#1A1A1A" \
        -urgent-fg-color "#C0C0C0" \
        -urgent-bg-color "#1A1A1A" \
        -middle-bg-color "#1A1A1A" \
        -middle-bg-color-selected "#1A1A1A" &
}

# Function to get CPU usage
get_cpu() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1
}

# Function to get RAM usage
get_ram() {
    free -m | awk '/Mem:/ {printf "%d", ($3/$2)*100}'
}

# Function to get date and time
get_datetime() {
    date "+%Y-%m-%d %H:%M"
}

# Function to get weather
get_weather() {
    CACHE_FILE="/tmp/weather.cache"
    CACHE_LIFE=1800 # 30 minutes

    if [ -f "$CACHE_FILE" ]; then
        CACHE_TIME=$(stat -c %Y "$CACHE_FILE")
        CURRENT_TIME=$(date +%s)
        if [ $((CURRENT_TIME - CACHE_TIME)) -lt $CACHE_LIFE ]; then
            cat "$CACHE_FILE"
            return
        fi
    fi

    weather_data=$(curl -s "wttr.in/Winschoten?format=%c+%t+%h" 2>/dev/null)
    
    weather_symbol=$(echo "$weather_data" | awk '{print $1}')
    temp=$(echo "$weather_data" | awk '{print $2}')
    humidity=$(echo "$weather_data" | awk '{print $3}')
    
    case "$weather_symbol" in
        "☀️"|"Clear") symbol="☼ " ;;
        "⛅️"|"🌤"|"Partly cloudy") symbol="⛅ " ;;
        "☁️"|"🌥"|"Cloudy"|"Overcast") symbol="☁ " ;;
        "🌦"|"🌧"|"Rain") symbol="☔ " ;;
        "🌩"|"⛈"|"Thunder") symbol="⛈ " ;;
        "🌨"|"Snow") symbol="❄ " ;;
        "🌫"|"Fog"|"Mist") symbol="≡ " ;;
        *) symbol="$weather_symbol " ;;
    esac

    weather_info="${symbol}${temp} ${humidity}"
    echo "$weather_info" > "$CACHE_FILE"
    echo "$weather_info"
}

# Function to update status
update_status() {
    while true; do
        cpu=$(get_cpu)
        ram=$(get_ram)
        datetime=$(get_datetime)
        weather=$(get_weather)
        
        # Updated status with weather, keepassxc, alsamixer, and brackets
        dwlb -status all "\
^fg(#287373)❬ CPU: ${cpu}% ❭ ^fg(#899CA1)⡇ \
^fg(#31658C)❬ RAM: ${ram}% ❭ ^fg(#899CA1)⡇ \
^fg(#7E5D7A)❬ ${weather} ❭ ^fg(#899CA1)⡇ \
^fg(#7E5D7A)❬ ${datetime} ❭ ^fg(#899CA1)⡇ \
^bg(#1A1A1A)^lm(keepassxc)^fg(#C0C0C0)🔒^lm()^bg() ^fg(#899CA1)⡇ \
^bg(#1A1A1A)^lm(st -e alsamixer)^fg(#C0C0C0)🔈^lm()^bg() ^fg(#899CA1)⡇ \
^bg(#395573)^lm(/usr/bin/code-oss --ozone-platform-hint=auto)^fg(#C0C0C0) CODE ^lm()^bg()"
        
        sleep 120
    done
}

# Kill any existing dwlb instances and status loops
# pkill -f "dwlb.sh" || true
# killall dwlb 2>/dev/null

# Launch dwlb
launch_dwlb

# Wait for dwlb to start
sleep 1

# Start status update loop
update_status &

# Wait for dwlb to exit
wait
