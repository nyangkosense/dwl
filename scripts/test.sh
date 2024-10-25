#!/bin/bash

TERMINAL="kitty"
ALSAMIXER_CMD="$TERMINAL -e alsamixer"
 #       -center-title \
# Launch dwlb with JWR dark theme using PragmataPro
launch_dwlb() {
    dwlb -ipc \
        -status-commands \
        -font "PragmataPro:size=13" \
        -vertical-padding 6 \
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


# Sys 
get_cpu() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1
}

get_ram() {
    free -m | awk '/Mem:/ {printf "%d", ($3/$2)*100}'
}

get_datetime() {
    local date_part=$(date "+%Y-%m-%d")
    local time_part=$(date "+%H:%M")
    echo "${date_part} ${time_part}"
}

# Function to get weather with enhanced symbols
get_weather() {
    CACHE_FILE="/tmp/weather.cache"
    CACHE_LIFE=1800

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
        "☀️"|"Clear") symbol="􀆫" ;;          # Sun
        "⛅️"|"🌤"|"Partly cloudy") symbol="􀆭" ;; # Sun behind cloud
        "☁️"|"🌥"|"Cloudy"|"Overcast") symbol="􀇀" ;; # Cloud
        "🌦"|"🌧"|"Rain") symbol="􀇖" ;;      # Cloud with rain
        "🌩"|"⛈"|"Thunder") symbol="􀇘" ;;    # Cloud with lightning
        "🌨"|"Snow") symbol="􀇗" ;;           # Cloud with snow
        "🌫"|"Fog"|"Mist") symbol="􀇂" ;;     # Fog
        *) symbol="􀆬" ;;                     # Default to sun
    esac

    weather_info="${symbol} ${temp} 􀇬 ${humidity}"  # Using 􀇬 for humidity
    echo "$weather_info" > "$CACHE_FILE"
    echo "$weather_info"
}

# Function to get network status for enp12s0
get_network() {
    local wired="enp12s0"
    local wireless="wlan0"
    
    if [ -e "/sys/class/net/${wired}" ]; then
        local wired_state=$(cat "/sys/class/net/${wired}/operstate")
        if [ "$wired_state" = "up" ]; then
            echo "󰌘"  # Connected ethernet
            return
        else
            echo "󰌙"  # Disconnected ethernet
            return
        fi
    fi
    
    if [ -e "/sys/class/net/${wireless}" ]; then
        local wifi_state=$(cat "/sys/class/net/${wireless}/operstate")
        if [ "$wifi_state" = "up" ]; then
            echo "󰤨"
        else
            echo "󰤭"
        fi
    else
        echo "󰯡"  # Network error
    fi
}

# Setting status
update_status() {
    while true; do
        local cpu_val=$(get_cpu)
        local ram_val=$(get_ram)
        local weather=$(get_weather)
        local network=$(get_network)
        local date_part=$(date "+%d-%m-%Y")
        local time_part=$(date "+%H:%M")
        
        dwlb -status all "\
^fg(#287373)⎿^fg(#53A6A6)󰻠 ${cpu_val}%^fg(#287373)⏋ \
^fg(#31658C)⎿^fg(#6096BF)󰍛 ${ram_val}%^fg(#31658C)⏋ \
^fg(#7E5D7A)⎿^fg(#A270A3)${weather}^fg(#7E5D7A)⏋ \
^fg(#5E468C)⎿^fg(#7E62B3)${network}^fg(#5E468C)⏋ \
^fg(#5E468C)⎿^fg(#7E62B3)󰃭 ${date_part} 󱑍 ${time_part}^fg(#5E468C)⏋ \
^fg(#899CA1)󰇝 \
^bg(#8C4665)^lm(qutebrowser protonmail.com)^fg(#C0C0C0)⎿󰊫 Mail⏋^lm()^bg() \
^fg(#899CA1)󰇝 \
^bg(#31658C)^lm(qutebrowser reddit.com)^fg(#C0C0C0)⎿󰑍 Reddit⏋^lm()^bg() \
^fg(#899CA1)󰇝 \
^bg(#5E468C)^lm(keepassxc)^fg(#C0C0C0)⎿󰌆 Pass⏋^lm()^bg() \
^fg(#899CA1)󰇝 \
^bg(#287373)^lm(st -e alsamixer)^fg(#C0C0C0)⎿󰕾 Vol⏋^lm()^bg() \
^fg(#899CA1)󰇝 \
^bg(#31658C)^lm(qutebrowser open.spotify.com)^fg(#C0C0C0)⎿󰓇 Music⏋^lm()^bg() \
^fg(#899CA1)󰇝 \
^bg(#395573)^lm(/usr/bin/code-oss --ozone-platform-hint=auto)^fg(#C0C0C0)⎿󰨞 Code⏋^lm()^bg()"
        
        count=$((count - 1))
        sleep 1
    done
}

# Kill any existing processes
pkill -f "launch-dwlb.sh" || true
killall dwlb 2>/dev/null

# Launch dwlb
launch_dwlb

# Wait for dwlb to start
sleep 1

# Start status update loop
update_status &

# Wait for dwlb to exit
wait





