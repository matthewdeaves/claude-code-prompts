# Claude Code Prompts & Configs

A library of useful skills, statuslines, and configs for Claude Code.

## Available Skills

| Skill | Description |
|-------|-------------|
| `evaluate-plan` | Evaluates project plans for Claude Code compatibility. Reviews task granularity, dependencies, and testability. |

## Available Statuslines

| Statusline | Description |
|------------|-------------|
| `git-context` | Shows model, directory, git repo:branch, and context window usage percentage |

Example output: `[Opus] 📁 myproject | user/repo:main | context:42%`

## Installation

### Quick Install

```bash
# Clone the repo
git clone https://github.com/matthewdeaves/claude-code-prompts
cd claude-code-prompts

# List everything available
./install.sh

# Install everything (all skills + default statusline)
./install.sh --all

# Install a specific skill
./install.sh evaluate-plan

# Install all skills only
./install.sh --all-skills

# Install a specific statusline
./install.sh --statusline git-context
```

### Manual Install

**Skills** - copy to your personal skills directory:
```bash
cp -r claude/skills/evaluate-plan ~/.claude/skills/
```

**Statuslines** - copy script and update settings:
```bash
cp statuslines/git-context.sh ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

Then add to `~/.claude/settings.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

## Usage

Skills are tools that Claude chooses to use based on your request - they're not direct slash commands. After installation, trigger skills in any Claude Code session by:

**Ask naturally:**
```
Review my project plan for Claude Code compatibility
```
```
Evaluate this implementation plan
```

Claude will recognise the skill applies and ask to use it.

**Or ask Claude to run it:**
```
Run /evaluate-plan on my plan
```
```
Use the evaluate-plan skill to review this plan
```

Claude will search your project for plans and assess them against best practices for iterative development with Claude Code. You can also paste a plan directly or point to a specific file.
