# Claude Code Prompts & Configs

A library of useful skills, statuslines, and configs for Claude Code.

## Available Skills

| Skill | Description |
|-------|-------------|
| `committing` | Smart git commits with security checks, .gitignore validation, and intelligent commit messages. |
| `checking-implementability` | Check if your implementation plan will succeed with Claude Code. Evaluates task granularity, context management, test coverage, and phase splitting. |
| `creating-qa-rounds` | Create structured QA round documents for manual testing phases. Generates tracking docs with issue logging, session planning, and verification workflows. |

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
./install.sh checking-implementability

# Install all skills only
./install.sh --all-skills

# Install a specific statusline
./install.sh --statusline git-context
```

**Note:** The installer backs up any existing statusline before overwriting, so you won't lose your current setup.

### Manual Install

**Skills** - copy to your personal skills directory:
```bash
cp -r skills/checking-implementability ~/.claude/skills/
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
/checking-implementability
```
```
/committing
```

### Skill Details

#### checking-implementability

Checks if your implementation plan will succeed with Claude Code — evaluates whether phases fit context windows, assesses task granularity, dependencies, test coverage, and ensures work follows iterative patterns.

**Recommended Workflow:**

This skill works best as a quality gate within an iterative planning process:

1. **Draft in planning mode** - Use Claude Code's planning mode to develop your implementation plan. Request multiple rounds of refinement:
   - Identify gaps in specification
   - Review architecture for potential issues
   - Expand solution design details
   - Improve task breakdown and session boundaries
   - Continue until the plan covers all requirements

2. **Check** - Run `/checking-implementability` to assess the plan against Claude Code best practices

3. **Address recommendations** - Implement suggested changes (supporting infrastructure, task clarity, test coverage)

4. **Re-check** - Run the skill again and repeat until the assessment indicates the plan is ready to implement

This iterative approach produces plans that work reliably with Claude Code's session-based workflow.

**Key Evaluation Criteria:**

The skill evaluates 9 core criteria:
1. **Task Granularity** - Ensures tasks are focused, actionable, and completable in focused sessions
2. **Dependency Structure** - Validates that foundational components are scheduled before dependent features
3. **Instruction Clarity** - Checks that tasks are specific with defined success criteria
4. **Testability** - Verifies tests are built into each session (not deferred to later)
5. **Context Management** - Validates that information is organized for per-task context loading
6. **Supporting Infrastructure** - Checks for CLAUDE.md, workflow docs, CI/CD, security scanning
7. **Manual Testing & QA Workflow** - Evaluates QA tracking structure (when applicable)
8. **State Management** - Ensures phases/sessions have progress tracking
9. **Architectural Patterns** - Detects monolithic files, missing refactoring steps, and shared utilities

**Document Splitting Recommendations:**
- Detects monolithic plans (5+ phases in one file) and recommends splitting into separate `PHASE-N-NAME.md` files
- Recommends splitting QA documents (30+ issues) by testing round or platform
- Validates that split documents follow modular patterns

**How to invoke:**
```
# Ask naturally
Is my plan implementable?
Check if this plan will work with Claude Code

# Or use the skill directly
/checking-implementability
```

**Example output:**
- Overall rating (Implementable / Needs Work / Not Yet Implementable)
- Planning ecosystem found (docs, supporting files)
- Strengths identified
- Test coverage assessment (frontend/backend layers)
- Security scanning assessment
- State management assessment
- Issues found with specific recommendations
- Suggested changes

See [cookie](https://github.com/matthewdeaves/cookie) for an example — the [WORKFLOW.md](https://github.com/matthewdeaves/cookie/blob/master/WORKFLOW.md) and [modular phase structure](https://github.com/matthewdeaves/cookie/tree/master/plans) demonstrate the recommended planning patterns.

---

#### creating-qa-rounds

Create structured QA round documents for manual testing phases. Generates tracking docs with issue logging, session planning, and verification workflows.

**When to use:**
- Implementation work is complete and needs manual testing
- UI/UX features need verification across devices/browsers
- A feature has acceptance criteria that require hands-on testing
- You need to organize manual testing into structured rounds

**What it creates:**

A `QA-ROUND-N-FEATURE.md` document with:
1. **Issue Log Table** - Track discovered issues with IDs, status, and session assignments
2. **Test Scenarios** - Derived from implementation plan's acceptance criteria
3. **Session Scope** - Group related issues into focused fix sessions
4. **Workflow Instructions** - Ready-to-use prompts for research, fix, and verification sessions
5. **State Tracking** - Progress visibility using unified state model

**How to invoke:**
```
# Create a QA round for completed work
create QA Round 1 for user authentication
start QA round for Recipe Remix
set up QA testing for the dashboard feature

# Or use the skill directly
/creating-qa-rounds
```

**QA Workflow:**

The generated document supports this 4-phase workflow:
1. **Test & Log** - Find issues on device, record with ID, summary, screenshots
2. **Research** - For each issue, investigate before defining the fix (check existing patterns, design specs)
3. **Plan & Fix** - Define tasks based on research, implement in focused session
4. **Verify** - Confirm deployment, clear caches, test on target devices

**Document splitting:**
- Small projects (1-15 issues): Single `QA-TESTING.md`
- Medium projects (15-40 issues): Numbered rounds (`QA-ROUND-1.md`, `QA-ROUND-2.md`)
- Large projects (40+ issues): Split by platform (`QA-MOBILE.md`, `QA-DESKTOP.md`) or round

**Templates:**

Uses templates from `skills/checking-implementability/templates/`:
- `QA-ROUND-TEMPLATE.md` - Full round structure
- `QA-ISSUE-TEMPLATE.md` - Individual issue tracking

Note: The cookie project's [QA-TESTING.md](https://github.com/matthewdeaves/cookie/blob/master/QA-TESTING.md) uses a monolithic structure (developed before this skill existed); new projects benefit from feature-scoped QA rounds.

---

#### committing

Analyzes your working tree, checks for missing .gitignore entries, scans for secrets/API keys, suggests staging changes, and generates a conventional commit message based on the actual changes. When QA tracking documents are present, automatically formats messages to link code changes to specific issues (e.g., QA-013, #42) with clear explanations of what each file change accomplishes.

**How to invoke:**
```
# Ask naturally
Commit my changes
Create a commit

# Or use the skill directly
/committing
```
