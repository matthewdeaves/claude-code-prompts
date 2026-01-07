# Claude Code Prompts & Skills

A library of useful prompts and skills for Claude Code to help with software engineering projects.

## Available Skills

| Skill | Description |
|-------|-------------|
| `evaluate-plan` | Evaluates project plans for Claude Code compatibility. Reviews task granularity, dependencies, and testability. |

## Installation

### Quick Install

```bash
# Clone the repo
git clone <repo-url>
cd prompts

# Install a specific skill
./install.sh evaluate-plan

# Or install all skills
./install.sh --all
```

### Manual Install

Copy the skill folder to your personal Claude skills directory:

```bash
cp -r claude/skills/evaluate-plan ~/.claude/skills/
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
