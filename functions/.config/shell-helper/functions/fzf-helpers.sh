#!/bin/bash

ivf() {
    local file_and_line
    file_and_line=$(rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always '{1}' --highlight-line '{2} \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
            
    if [[ -n "$file_and_line" ]]; then
        local file=$(echo "$file_and_line" | awk -F: '{print $1}')
        local line=$(echo "$file_and_line" | awk -F: '{print $2}')
        nvim "+${line}" "$file"
    fi
}

iv() {
    local files
    # -m allows multi-selection (use Tab to select multiple files)
    # --preview uses bat to show the first 500 lines with syntax highlighting
    files=$(fzf -m --preview 'bat --style=numbers --color=always --line-range :500 {}')
    
    # Only open nvim if a file was actually selected
    if [[ -n "$files" ]]; then
        # Use xargs to handle multiple files properly, opening them in nvim
        echo "$files" | xargs -ro nvim
    fi
}
