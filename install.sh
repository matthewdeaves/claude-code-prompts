#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
SKILLS_DEST="$HOME/.claude/skills"
STATUSLINES_SRC="$SCRIPT_DIR/statuslines"
CLAUDE_CONFIG="$HOME/.claude/settings.json"

show_help() {
    echo "Claude Code Prompts & Configs Installer"
    echo
    echo "Usage:"
    echo "  ./install.sh                     List all available items"
    echo "  ./install.sh --all               Install everything (all skills + default statusline)"
    echo "  ./install.sh <skill-name>        Install a specific skill"
    echo "  ./install.sh --all-skills        Install all skills"
    echo "  ./install.sh --statusline <name> Install a statusline"
    echo
    list_skills
    list_statuslines
}

list_skills() {
    echo "Available skills:"
    echo
    for dir in "$SKILLS_SRC"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            # Extract description from SKILL.md frontmatter
            desc=$(sed -n '/^description:/p' "$dir/SKILL.md" 2>/dev/null | sed 's/^description: //')
            printf "  %-20s %s\n" "$skill_name" "${desc:0:60}"
        fi
    done
    echo
}

list_statuslines() {
    echo "Available statuslines:"
    echo
    for file in "$STATUSLINES_SRC"/*.sh; do
        if [ -f "$file" ]; then
            name=$(basename "$file" .sh)
            # Extract description from comment header
            desc=$(sed -n '3s/^# //p' "$file" 2>/dev/null)
            printf "  %-20s %s\n" "$name" "$desc"
        fi
    done
    echo
    echo "Install with: ./install.sh --statusline <name>"
    echo
}

install_skill() {
    local skill_name="$1"
    local src="$SKILLS_SRC/$skill_name"

    if [ ! -d "$src" ]; then
        echo "Error: Skill '$skill_name' not found"
        echo
        list_skills
        exit 1
    fi

    mkdir -p "$SKILLS_DEST"
    cp -r "$src" "$SKILLS_DEST/"
    echo "Installed skill '$skill_name' to $SKILLS_DEST/$skill_name"
}

install_all_skills() {
    mkdir -p "$SKILLS_DEST"
    for dir in "$SKILLS_SRC"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            cp -r "$dir" "$SKILLS_DEST/"
            echo "Installed skill '$skill_name'"
        fi
    done
    echo "All skills installed to $SKILLS_DEST"
}

install_all() {
    echo "Installing all skills..."
    install_all_skills
    echo
    echo "Installing default statusline (git-context)..."
    install_statusline "git-context"
    echo
    echo "All done! Restart Claude Code to see your new statusline."
}

install_statusline() {
    local name="$1"
    local src="$STATUSLINES_SRC/$name.sh"

    if [ ! -f "$src" ]; then
        echo "Error: Statusline '$name' not found"
        echo
        list_statuslines
        exit 1
    fi

    local dest="$HOME/.claude/statusline.sh"
    mkdir -p "$HOME/.claude"

    # Back up existing statusline script if present
    if [ -f "$dest" ]; then
        local backup="$dest.bak.$(date +%Y%m%d_%H%M%S)"
        cp "$dest" "$backup"
        echo "Backed up existing statusline to $backup"
    fi

    # Copy new script
    cp "$src" "$dest"
    chmod +x "$dest"

    # Update settings.json
    if [ -f "$CLAUDE_CONFIG" ]; then
        # Check if there's an existing statusLine config
        existing=$(jq -r '.statusLine // empty' "$CLAUDE_CONFIG" 2>/dev/null)
        if [ -n "$existing" ]; then
            echo "Note: Updating existing statusLine configuration"
        fi
        # Backup existing config
        cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.bak"
        # Update statusLine setting using jq
        jq '.statusLine = {"type": "command", "command": "bash ~/.claude/statusline.sh"}' "$CLAUDE_CONFIG" > "$CLAUDE_CONFIG.tmp" && mv "$CLAUDE_CONFIG.tmp" "$CLAUDE_CONFIG"
    else
        # Create new config
        echo '{"statusLine": {"type": "command", "command": "bash ~/.claude/statusline.sh"}}' | jq . > "$CLAUDE_CONFIG"
    fi

    echo "Installed statusline '$name'"
    echo "  Script: $dest"
    echo "  Config: $CLAUDE_CONFIG"
    echo
    echo "Restart Claude Code to see the new statusline."
}

# Main
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    --all)
        install_all
        ;;
    --all-skills|-a)
        install_all_skills
        ;;
    --statusline|-s)
        if [ -z "$2" ]; then
            echo "Error: Please specify a statusline name"
            echo
            list_statuslines
            exit 1
        fi
        install_statusline "$2"
        ;;
    --help|-h)
        show_help
        ;;
    *)
        install_skill "$1"
        ;;
esac
