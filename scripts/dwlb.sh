#!/bin/bash

# Launch dwlb with JWR dark theme - all backgrounds set to terminal background color
launch_dwlb() {
    dwlb -ipc \
        -status-commands \
        -center-title \
        -font "GohuFont:pixelsize=15" \
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

# Function to update status
update_status() {
    while true; do
        cpu=$(get_cpu)
        ram=$(get_ram)
        datetime=$(get_datetime)
        
        # Using command syntax for code-oss
        dwlb -status all "^fg(#287373)CPU: ${cpu}% ^fg(#899CA1)| ^fg(#31658C)RAM: ${ram}% ^fg(#899CA1)| ^fg(#7E5D7A)${datetime} ^fg(#899CA1)| ^bg(#395573)^lm(/usr/bin/code-oss --ozone-platform-hint=auto)^fg(#C0C0C0) CODE ^lm()^bg()"
        
        sleep 2
    done
}

# Kill any existing dwlb instances and status loops
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
