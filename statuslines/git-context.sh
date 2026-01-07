#!/bin/bash
#
# Shows model, directory, git repo:branch, and context usage %
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

# Extract context window usage - include all token types
usage=$(echo "$input" | jq '.context_window.current_usage')

if [ "$usage" != "null" ]; then
    # Sum all token sources: input + cache_creation + cache_read
    current_tokens=$(echo "$usage" | jq '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)')
    max_tokens=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

    if [ "$max_tokens" -gt 0 ] 2>/dev/null && [ "$current_tokens" != "null" ] && [ "$current_tokens" -gt 0 ] 2>/dev/null; then
        context_pct=$((current_tokens * 100 / max_tokens))
    else
        context_pct=0
    fi
else
    context_pct=0
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

    echo "[$model] 📁 $dir_name | $repo_name:$branch | context:${context_pct}%"
else
    echo "[$model] 📁 $dir_name | context:${context_pct}%"
fi
