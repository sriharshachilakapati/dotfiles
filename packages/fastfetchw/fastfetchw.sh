#!/bin/bash

capture_term_size() {
    current_lines=$(tput lines)
    current_columns=$(tput cols)
}

store_term_size() {
    previous_lines=$(tput lines)
    previous_columns=$(tput cols)
}

run_fastfetch() {
    clear
    fastfetch -c neofetch.jsonc
    last_update_time=$(date +%s)
}

capture_term_size
store_term_size
run_fastfetch

while [ true ]; do
    capture_term_size

    if [[ "$current_lines" -ne "$previous_lines" || "$current_columns" -ne "$previous_columns" ]]; then
        run_fastfetch
        store_term_size
    fi

    if (( $(date +%s) - last_update_time >= 60 )); then
        run_fastfetch
    fi

    sleep 1s
done
