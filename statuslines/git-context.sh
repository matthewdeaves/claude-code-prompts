#!/bin/bash
#
# Shows model, directory, git repo:branch, and context % remaining until auto-compact
#
# Install: ./install.sh --statusline git-context
# Or manually add to ~/.claude/settings.json:
# {
#   "statusLine": {
#     "type": "command",
#     "command": "bash ~/.claude/statusline.sh"
#   }
# }

# Read JSON input from stdin
input=$(cat)

# Extract model display name and current directory
model=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$current_dir")

# Extract context window usage - include all token types (input AND output)
usage=$(echo "$input" | jq '.context_window.current_usage')

# Auto-compact buffer: Claude Code reserves ~40K tokens before triggering compact
# This means usable context = context_window_size - buffer
AUTO_COMPACT_BUFFER=40000

if [ "$usage" != "null" ]; then
    # Sum ALL token sources: input + cache_creation + cache_read + output
    # Output tokens also consume context window space
    current_tokens=$(echo "$usage" | jq '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0) + (.output_tokens // 0)')
    max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

    if [ "$max_tokens" -gt 0 ] 2>/dev/null && [ "$current_tokens" != "null" ] && [ "$current_tokens" -gt 0 ] 2>/dev/null; then
        # Calculate usable context (total minus auto-compact buffer)
        usable_tokens=$((max_tokens - AUTO_COMPACT_BUFFER))

        # Calculate % remaining until auto-compact (matches Claude's "Context left until auto-compact")
        tokens_remaining=$((usable_tokens - current_tokens))
        if [ "$tokens_remaining" -lt 0 ]; then
            tokens_remaining=0
        fi
        context_left_pct=$((tokens_remaining * 100 / usable_tokens))
    else
        context_left_pct=100
    fi
else
    context_left_pct=100
fi

# Get git repository info
cd "$current_dir" 2>/dev/null

if git rev-parse --git-dir > /dev/null 2>&1; then
    repo_name=$(git config --get remote.origin.url 2>/dev/null | sed -e 's/.*[:/]\([^/]*\/[^/]*\)\.git$/\1/' -e 's/.*[:/]\([^/]*\/[^/]*\)$/\1/')

    if [ -z "$repo_name" ]; then
        repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        repo_name=$(basename "$repo_root")
    fi

    branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    echo "[$model] 📁 $dir_name | $repo_name:$branch | ctx left:${context_left_pct}%"
else
    echo "[$model] 📁 $dir_name | ctx left:${context_left_pct}%"
fi
