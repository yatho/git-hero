#!/bin/bash
#
# Git Hero - Shared Demo Utilities
# Common functions for interactive Git demonstrations
# NG Baguette Conf 2026
#

# =====================
# Configuration
# =====================

# Typewriter effect delay (seconds between characters)
DELAY_BETWEEN_CHARS=0.07

# Color codes
COLOR_RESET='\033[0m'
COLOR_PROMPT='\033[1;32m'      # Green for prompt
COLOR_ANNOUNCE='\033[1;33m'    # Yellow for announcements
COLOR_SUCCESS='\033[1;32m'     # Green for success
COLOR_INFO='\033[1;34m'        # Blue for info
COLOR_WARNING='\033[1;33m'     # Yellow for warnings
COLOR_ERROR='\033[1;31m'       # Red for errors

# Prompt prefix
PROMPT_COLOR="${COLOR_PROMPT}\$ ${COLOR_RESET}"

# Auto-pause mode (can be disabled with --no-pause)
AUTO_PAUSE=true
if [[ "$1" == "--no-pause" ]] || [[ "$2" == "--no-pause" ]]; then
    AUTO_PAUSE=false
fi

# =====================
# Core Functions
# =====================

# Display text with typewriter effect
# Usage: typewriter "command text"
typewriter() {
    local cmd="$1"
    echo -ne "$PROMPT_COLOR"
    for ((i=0; i<${#cmd}; i++)); do
        echo -n "${cmd:$i:1}"
        if [[ "$AUTO_PAUSE" == true ]]; then
            sleep $DELAY_BETWEEN_CHARS
        fi
    done
    echo
}

# Execute a command with typewriter effect and optional pause
# Usage: run "command" [should_pause]
# should_pause defaults to true
run() {
    local cmd="$1"
    local should_pause="${2:-true}"
    typewriter "$cmd"
    eval "$cmd"
    if [[ "$should_pause" != false ]]; then
        pause
    fi
}

# Pause and wait for user input
# Allows ad-hoc commands to be entered during pauses
pause() {
    if [[ "$AUTO_PAUSE" == true ]]; then
        read -r -p ""
        # If user enters a command, execute it and pause again
        if [[ -n "$REPLY" ]]; then
            run "$REPLY"
            pause
        fi
    fi
}

# Display announcement/section header
# Usage: announce "Section Title"
announce() {
    echo
    echo -e "${COLOR_ANNOUNCE}# $1${COLOR_RESET}"
    pause
}

# =====================
# Colored Output Functions
# =====================

# Display success message
# Usage: success "Success message"
success() {
    echo -e "${COLOR_SUCCESS}✅ $1${COLOR_RESET}"
}

# Display info message
# Usage: info "Info message"
info() {
    echo -e "${COLOR_INFO}ℹ️  $1${COLOR_RESET}"
}

# Display warning message
# Usage: warning "Warning message"
warning() {
    echo -e "${COLOR_WARNING}⚠️  $1${COLOR_RESET}"
}

# Display error message
# Usage: error "Error message"
error() {
    echo -e "${COLOR_ERROR}❌ $1${COLOR_RESET}"
}

# =====================
# File Display Functions
# =====================

# Display file contents with optional highlighting
# Usage: show_file "filename"
show_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        error "File not found: $file"
        return 1
    fi

    info "Contents of $file:"
    if command -v bat &> /dev/null; then
        bat "$file" --style=plain --paging=never
    elif command -v pygmentize &> /dev/null; then
        pygmentize "$file"
    else
        cat "$file"
    fi
}

# Display git diff with context
# Usage: show_diff [git diff args]
show_diff() {
    if command -v delta &> /dev/null; then
        git diff "$@" | delta
    else
        git diff --color "$@"
    fi
}

# =====================
# Git Helper Functions
# =====================

# Display pretty git log
# Usage: git_log_pretty [number of commits]
git_log_pretty() {
    local count="${1:-10}"
    git log --oneline --graph --decorate --color -n "$count"
}

# Display git status with explanation
# Usage: show_status
show_status() {
    info "Current repository status:"
    git status
}

# Display git branches with current highlighted
# Usage: show_branches
show_branches() {
    info "Repository branches:"
    git branch -vv --color
}

# Display current commit info
# Usage: show_current_commit
show_current_commit() {
    info "Current commit:"
    git log -1 --pretty=format:"%C(yellow)%h%C(reset) - %s %C(dim)(%ar by %an)%C(reset)" --abbrev-commit
    echo
}

# =====================
# Utility Functions
# =====================

# Clear screen with optional header
# Usage: clear_screen ["Optional header text"]
clear_screen() {
    clear
    if [[ -n "$1" ]]; then
        announce "$1"
    fi
}

# Display confirmation prompt
# Usage: confirm "Question?" && do_something
confirm() {
    local question="$1"
    local answer
    read -r -p "$question (y/n) " answer
    case "$answer" in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        * ) echo "Please answer yes or no."; confirm "$question";;
    esac
}

# Display a separator line
# Usage: separator
separator() {
    echo
    echo "─────────────────────────────────────────────────"
    echo
}

# Display a box with text
# Usage: box "Title" "Line 1" "Line 2" ...
box() {
    local width=60
    local line="┌"
    for ((i=0; i<width-2; i++)); do line="${line}─"; done
    line="${line}┐"

    echo -e "${COLOR_INFO}${line}${COLOR_RESET}"

    for text in "$@"; do
        local padding=$((width - ${#text} - 4))
        local pad_left=$((padding / 2))
        local pad_right=$((padding - pad_left))

        local padded_line="│ "
        for ((i=0; i<pad_left; i++)); do padded_line="${padded_line} "; done
        padded_line="${padded_line}${text}"
        for ((i=0; i<pad_right; i++)); do padded_line="${padded_line} "; done
        padded_line="${padded_line} │"

        echo -e "${COLOR_INFO}${padded_line}${COLOR_RESET}"
    done

    line="└"
    for ((i=0; i<width-2; i++)); do line="${line}─"; done
    line="${line}┘"
    echo -e "${COLOR_INFO}${line}${COLOR_RESET}"
}

# =====================
# Demo Control Functions
# =====================

# Start demo with introduction
# Usage: start_demo "Demo Title" "Description"
start_demo() {
    clear
    box "$1" "$2"
    pause
}

# End demo with summary
# Usage: end_demo "Takeaway 1" "Takeaway 2" ...
end_demo() {
    echo
    separator
    success "Demo Complete!"
    echo
    echo "Key Takeaways:"
    for takeaway in "$@"; do
        echo "  • $takeaway"
    done
    echo
}

# =====================
# Initialization
# =====================

# Export functions for use in other scripts
export -f typewriter
export -f run
export -f pause
export -f announce
export -f success
export -f info
export -f warning
export -f error
export -f show_file
export -f show_diff
export -f git_log_pretty
export -f show_status
export -f show_branches
export -f show_current_commit
export -f clear_screen
export -f confirm
export -f separator
export -f box
export -f start_demo
export -f end_demo
