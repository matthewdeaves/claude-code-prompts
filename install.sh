#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/claude/skills"
SKILLS_DEST="$HOME/.claude/skills"

list_skills() {
    echo "Available skills:"
    echo
    for dir in "$SKILLS_SRC"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            # Extract description from SKILL.md frontmatter
            desc=$(sed -n '/^description:/p' "$dir/SKILL.md" 2>/dev/null | sed 's/^description: //')
            printf "  %-20s %s\n" "$skill_name" "$desc"
        fi
    done
    echo
    echo "Usage:"
    echo "  ./install.sh <skill-name>    Install a specific skill"
    echo "  ./install.sh --all           Install all skills"
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
    echo "Installed '$skill_name' to $SKILLS_DEST/$skill_name"
}

install_all() {
    mkdir -p "$SKILLS_DEST"
    for dir in "$SKILLS_SRC"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            cp -r "$dir" "$SKILLS_DEST/"
            echo "Installed '$skill_name'"
        fi
    done
    echo
    echo "All skills installed to $SKILLS_DEST"
}

# Main
if [ $# -eq 0 ]; then
    list_skills
    exit 0
fi

case "$1" in
    --all|-a)
        install_all
        ;;
    --help|-h)
        list_skills
        ;;
    *)
        install_skill "$1"
        ;;
esac
