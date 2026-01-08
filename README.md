# Claude Code Prompts & Configs

A library of useful skills, statuslines, and configs for Claude Code.

## Available Skills

| Skill | Description |
|-------|-------------|
| `commit` | Smart git commits with security checks, .gitignore validation, and intelligent commit messages. |
| `implementable` | Check if your implementation plan will succeed with Claude Code. Evaluates whether phases fit context windows and follow iterative patterns. |

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
./install.sh implementable

# Install all skills only
./install.sh --all-skills

# Install a specific statusline
./install.sh --statusline git-context
```

**Note:** The installer backs up any existing statusline before overwriting, so you won't lose your current setup.

### Manual Install

**Skills** - copy to your personal skills directory:
```bash
cp -r skills/implementable ~/.claude/skills/
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
Is my plan implementable?
```
```
Commit my changes
```

Claude will recognise the skill applies and ask to use it.

**Or ask Claude to run it:**
```
/implementable
```
```
/commit
```

### Examples

**implementable**: Checks if your implementation plan will succeed with Claude Code — evaluates whether phases fit context windows, assesses task granularity, dependencies, and ensures work follows iterative patterns.

#### Recommended Workflow

This skill works best as a quality gate within an iterative planning process:

1. **Draft in planning mode** - Use Claude Code's planning mode to develop your implementation plan. Request multiple rounds of refinement:
   - Identify gaps in specification
   - Review architecture for potential issues
   - Expand solution design details
   - Improve task breakdown and session boundaries
   - Continue until the plan covers all requirements

2. **Check** - Run `/implementable` to assess the plan against Claude Code best practices

3. **Address recommendations** - Implement suggested changes (supporting infrastructure, task clarity, QA workflow)

4. **Re-check** - Run the skill again and repeat until the assessment indicates the plan is ready to implement

This iterative approach produces plans that work reliably with Claude Code's session-based workflow.

See [cookie](https://github.com/matthewdeaves/cookie) for an example — the [WORKFLOW.md](https://github.com/matthewdeaves/cookie/blob/master/WORKFLOW.md), [QA-TESTING.md](https://github.com/matthewdeaves/cookie/blob/master/QA-TESTING.md), and [modular phase structure](https://github.com/matthewdeaves/cookie/tree/master/plans) demonstrate the result of this workflow.

**commit**: Analyzes your working tree, checks for missing .gitignore entries, scans for secrets/API keys, suggests staging changes, and generates a conventional commit message based on the actual changes.
