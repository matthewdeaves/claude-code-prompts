# Claude Code Prompts & Configs

A library of useful skills, statuslines, and configs for Claude Code.

## Available Skills

| Skill | Description |
|-------|-------------|
| `blog-improver` | Evaluate blog post drafts and suggest improvements. Assesses against quality criteria and provides structured feedback for iteration. |
| `blog-writer` | Transform brain dumps into structured blog posts. Use 'discover' to find themes, 'skeleton' to create outlines, or 'write' to expand drafts. |
| `commit` | Smart git commits with security checks, .gitignore validation, and intelligent commit messages. |
| `implementable` | Check if your implementation plan will succeed with Claude Code. Evaluates task granularity, context management, phase splitting, and creates QA tracking infrastructure. |

## Available Statuslines

| Statusline | Description |
|------------|-------------|
| `git-context` | Shows model, directory, git repo:branch, and context % remaining until auto-compact |

Example output: `[Opus] 📁 myproject | user/repo:main | ctx left:42%`

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

**blog-writer**: Transform scattered notes into polished blog posts through a three-stage workflow:

```
/blog-writer discover ~/notes/     # Find themes ready to write about
/blog-writer skeleton              # Create structured outline from notes
/blog-writer write                 # Expand skeleton into full draft
```

The skeleton mode accepts natural language direction:
```
/blog-writer skeleton I want to write about the hidden costs of microservices.
Start with the promise they make, then show what happens at scale.
Pull from architecture-notes.md for examples.
```

**blog-improver**: Evaluate drafts against quality criteria and iterate until ready to publish:

```
/blog-improver                     # Evaluate draft in conversation
/blog-improver path/to/post.md     # Evaluate specific file
```

Provides structured feedback on thesis clarity, structure, voice, specificity, and flags common AI writing patterns to avoid.

**Recommended blog workflow:**
```
/blog-writer skeleton → review → /blog-writer write → /blog-improver → fix issues → repeat until ready
```

---

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

#### Key Capabilities

The skill evaluates 7 core criteria and provides specific recommendations:

**Planning Structure:**
- **Phase Splitting** - Detects monolithic plans (5+ phases in one file) and recommends splitting into separate `PHASE-N-NAME.md` files for better navigation and context management
- **Task Granularity** - Ensures tasks are focused, actionable, and completable in focused sessions
- **Context Management** - Validates that information is organized for per-task context loading

**QA Infrastructure:**
- **QA Round Detection** - When evaluating plans with completed work, detects features needing manual testing and suggests creating feature-scoped QA rounds
- **QA Round Creation** - Generates `QA-ROUND-N-FEATURE.md` documents on request with test scenarios extracted from implementation acceptance criteria
- **QA Document Splitting** - Recommends splitting monolithic QA files (30+ issues) by testing round or platform

**Usage Examples:**
```
# Evaluate a plan
/implementable

# Create a QA round for completed work
create QA Round 1 for Recipe Remix
```

The skill will either evaluate the plan (providing recommendations) or create QA infrastructure (generating documents), depending on your request.

See [cookie](https://github.com/matthewdeaves/cookie) for an example — the [WORKFLOW.md](https://github.com/matthewdeaves/cookie/blob/master/WORKFLOW.md) and [modular phase structure](https://github.com/matthewdeaves/cookie/tree/master/plans) demonstrate the recommended planning patterns. Note that the cookie project's [QA-TESTING.md](https://github.com/matthewdeaves/cookie/blob/master/QA-TESTING.md) uses a monolithic structure (developed before QA Round capabilities were added); new projects can use feature-scoped QA rounds instead.

**commit**: Analyzes your working tree, checks for missing .gitignore entries, scans for secrets/API keys, suggests staging changes, and generates a conventional commit message based on the actual changes. When QA tracking documents are present, automatically formats messages to link code changes to specific issues (e.g., QA-013, #42) with clear explanations of what each file change accomplishes.
