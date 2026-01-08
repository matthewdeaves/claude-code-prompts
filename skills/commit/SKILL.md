---
name: commit
description: Smart git commits with security checks, .gitignore validation, and intelligent commit messages. Analyzes your changes, catches potential secrets, generates conventional commit messages, and provides QA-aware formatting when issue tracking documents are present.
allowed-tools: Bash Read Grep Glob AskUserQuestion
---

# Smart Commit

Perform intelligent pre-commit analysis, security scanning, and generate high-quality conventional commit messages. Automatically detects QA/issue tracking work and generates contextual messages linking code changes to specific issues.

## Workflow

Execute these steps in order, interacting with the user at key decision points.

### Step 1: Analyze Working Tree

Run these git commands to understand the current state:

```bash
git status --porcelain
git diff --stat
git diff --cached --stat
```

Present a summary:
- Number of staged files
- Number of unstaged modified files
- Number of untracked files
- Brief description of what areas of the codebase are affected

### Step 2: Check .gitignore

First, check if .gitignore exists and read it. Then check for missing common patterns based on project indicators:

| If this exists | Suggest adding (if missing) |
|----------------|----------------------------|
| package.json | node_modules/, .npm/, *.tgz, .yarn/ |
| requirements.txt OR pyproject.toml OR setup.py | venv/, .venv/, __pycache__/, *.pyc, *.pyo, .eggs/, *.egg-info/ |
| Cargo.toml | target/ |
| go.mod | vendor/ (only if not intentionally vendoring) |
| .env file exists | .env, .env.*, .env.local |
| Any project | .DS_Store, Thumbs.db, *.log, *.tmp, *~ |
| .idea/ exists | .idea/ |
| .vscode/ exists | .vscode/ (optional - some teams commit this) |

If suggestions exist, use AskUserQuestion to ask if the user wants to add them to .gitignore.

### Step 3: Security Scan

Scan all staged and unstaged modified files for potential secrets. Use Grep to search for these patterns:

**API Keys:**
```
AKIA[0-9A-Z]{16}                    # AWS Access Key ID
sk-[a-zA-Z0-9]{20,}                 # OpenAI API Key
ghp_[a-zA-Z0-9]{36}                 # GitHub Personal Access Token
gho_[a-zA-Z0-9]{36}                 # GitHub OAuth Token
ghu_[a-zA-Z0-9]{36}                 # GitHub User Token
ghs_[a-zA-Z0-9]{36}                 # GitHub Server Token
glpat-[a-zA-Z0-9\-]{20}             # GitLab Personal Access Token
xox[baprs]-[a-zA-Z0-9\-]+           # Slack tokens
```

**Generic Secrets (in config-like files):**
```
password\s*[=:]\s*['"]?[^'"\s]+
secret\s*[=:]\s*['"]?[^'"\s]+
api[_-]?key\s*[=:]\s*['"]?[^'"\s]+
auth[_-]?token\s*[=:]\s*['"]?[^'"\s]+
```

**Private Keys:**
```
-----BEGIN (RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----
```

**Connection Strings with Credentials:**
```
(mysql|postgresql|postgres|mongodb|redis)://[^:]+:[^@]+@
```

If potential secrets are found:
1. Show exactly what was detected and in which file
2. Use AskUserQuestion to offer these options:
   - Unstage the file (if staged)
   - Add file/pattern to .gitignore
   - Proceed anyway (requires explicit confirmation)
   - Abort commit

### Step 4: Staging Review

Present the current staging state:
1. List all staged files
2. List unstaged modified files that might logically belong with this commit
3. List any large files (>1MB) or binary files that are staged (warn)

Use AskUserQuestion to ask if the user wants to:
- Stage additional related files
- Unstage any files
- Proceed with current staging

If the user wants to stage files, run the appropriate `git add` commands.

### Step 4.5: Detect QA Context (Optional)

Check if the changeset involves QA/issue tracking work:

1. **Look for QA tracking documents** in staged files:
   - Common patterns: `QA-TESTING.md`, `QA-*.md`, `ISSUES.md`, `BUGS.md`, `CHANGELOG.md`
   - Also check: `docs/qa/`, `testing/`, or similar directories

2. **If QA docs are present**, read the diff to extract:
   - Issue IDs being addressed (e.g., `QA-013`, `#42`, `BUG-123`, `ISSUE-456`)
   - Status changes (Fixed → Verified, Open → Fixed, etc.)
   - Issue descriptions/titles

3. **Parse issue context**:
   - Extract issue ID, title, and what changed (status, notes, etc.)
   - Note which issue IDs appear in the QA doc changes

4. **Map code changes to issues**:
   - Look at the other staged files (non-QA docs)
   - Try to infer which code changes address which issues based on:
     - File paths mentioned in issue descriptions
     - Component/feature names matching the issue
     - Logical grouping (e.g., all audio-related files likely address audio issue)

5. **Store QA context** for use in commit message generation:
   - List of issue IDs being addressed
   - For each issue: ID, title/description, related files
   - Overall theme (single issue fix, multi-issue batch, verification only, etc.)

**Detection patterns:**

Issue ID formats to recognize:
- `QA-###` (QA tracking)
- `####` (GitHub/GitLab issues)
- `BUG-###`, `ISSUE-###`, `TASK-###` (Jira-style)
- Custom patterns found in the project's QA docs

Skip this step if no QA tracking documents are in the changeset.

### Step 5: Generate Commit Message

Read the actual changes with `git diff --cached` to understand what was modified.

Determine the commit type based on the changes:
- `feat`: New feature or capability
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, whitespace (no code change)
- `refactor`: Code restructuring without behavior change
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `build`: Build system or dependencies
- `ci`: CI/CD configuration
- `chore`: Maintenance tasks, tooling

Generate a commit message following this format:
```
<type>: <subject>

<body>
```

**If QA context was detected in Step 4.5**, enhance the message structure:

**Single issue being addressed:**
```
<type>: <issue title/description> (<issue-id>)

<What was done to fix/verify the issue>:
- file1.js: Specific change and why it addresses the issue
- file2.css: Specific change and why it addresses the issue
- QA-TESTING.md: Updated status to <new status>
```

Example:
```
fix: Timer completion sound on Legacy/iOS 9 (QA-013)

Implement fix for QA-013:
- timer.js: Rewrote audio system with Web Audio API fallback for iOS 9
- play.js: Added gesture handlers to initialize audio (iOS requirement)
- QA-TESTING.md: Marked as verified on iOS 9 iPad 2
```

**Multiple issues being addressed:**
```
<type>: <Brief summary of issues> (<issue-id>, <issue-id>)

<Issue-id> - <Issue title>:
- file1.js: What changed to fix this issue
- file2.css: What changed to fix this issue

<Issue-id> - <Issue title>:
- file3.js: What changed to fix this issue

Updated <QA doc name> with verification status for all issues.
```

Example:
```
fix: Mobile audio and layout issues (QA-013, QA-014)

QA-013 - Timer completion sound on iOS 9:
- timer.js: Rewrote audio system with Web Audio API
- play.js: Added gesture handlers for audio init

QA-014 - Layout breaking on narrow screens:
- styles.css: Added responsive breakpoints below 320px
- header.js: Adjusted mobile menu behavior

Updated QA-TESTING.md with verification status for both issues.
```

**Verification-only (no code changes, just QA doc updates):**
```
test: Verify <issue description> (<issue-id>)

Tested and verified fix for <issue-id> on <platform/device>.
Updated QA-TESTING.md status to Verified.
```

**If NO QA context detected**, use standard format:

Rules for the subject line:
- Use imperative mood ("Add feature" not "Added feature")
- No period at the end
- 50 characters or less
- Capitalize the first letter after the type prefix

Rules for the body:
- Wrap at 72 characters
- Explain what and why, not how
- Reference related issues if apparent from the code
- **Link specific file changes to what they accomplish** (inspired by QA format)

Present the generated message to the user with AskUserQuestion:
- Accept the message
- Edit the message (provide text input)
- Regenerate with different focus

### Step 6: Execute Commit

Show a final summary:
- Files to be committed
- Commit message

Ask for final confirmation, then execute:
```bash
git commit -m "<message>"
```

If the commit includes a body, use:
```bash
git commit -m "<subject>" -m "<body>"
```

Show the result and the new commit hash.

## Important Notes

- Never run `git push` unless explicitly asked
- Never use `--force` flags
- Never modify git config
- If pre-commit hooks fail, show the error and let the user decide how to proceed
- Always preserve the user's ability to abort at any step

## Example Session Flows

### Example 1: Standard Commit (No QA Context)

```
Analyzing repository...

Found:
- 3 staged files
- 2 unstaged modified files
- 1 untracked file

.gitignore Check:
Missing recommended entries for a Node.js project:
- node_modules/ (already present)
- .env (MISSING - .env file exists!)

[Ask: Add .env to .gitignore?]

Security Scan:
Warning: Potential secret detected in config/database.js:12
  DATABASE_URL=postgres://admin:secretpass123@localhost/mydb

[Ask: How to handle this?]
- Unstage config/database.js
- Add to .gitignore
- Proceed anyway
- Abort

Staging Review:
Staged:
- src/feature.js (modified)
- src/feature.test.js (new)
- README.md (modified)

Related unstaged files:
- src/utils.js (modified in same area as feature.js)

[Ask: Stage src/utils.js too?]

Commit Message:
feat: Add user authentication feature

Implement login/logout functionality with session management:
- src/feature.js: Add auth API endpoints and session handling
- src/feature.test.js: Add unit tests for login/logout flow
- README.md: Document authentication setup

[Ask: Accept / Edit / Regenerate?]

Committing...
[abc1234] feat: Add user authentication feature
```

### Example 2: QA-Aware Commit (Single Issue)

```
Analyzing repository...

Found:
- 3 staged files (timer.js, play.js, QA-TESTING.md)

Security Scan: ✓ No issues found

Staging Review:
Staged:
- src/timer.js (modified)
- src/play.js (modified)
- QA-TESTING.md (modified)

QA Context Detected:
Found QA tracking document changes.

Issue being addressed:
- QA-013: "Timer completion sound on Legacy/iOS 9"
  Status changed: Fixed → Verified
  Related files: timer.js, play.js

Commit Message:
fix: Timer completion sound on Legacy/iOS 9 (QA-013)

Implement fix for QA-013:
- timer.js: Rewrote audio system with Web Audio API fallback for iOS 9
- play.js: Added gesture handlers to initialize audio (iOS requirement)
- QA-TESTING.md: Marked as verified on iOS 9 iPad 2

[Ask: Accept / Edit / Regenerate?]

Committing...
[def5678] fix: Timer completion sound on Legacy/iOS 9 (QA-013)
```

### Example 3: QA-Aware Commit (Multiple Issues)

```
Analyzing repository...

Found:
- 5 staged files

Staging Review:
Staged:
- src/timer.js (modified)
- src/play.js (modified)
- styles/mobile.css (modified)
- styles/layout.css (modified)
- QA-TESTING.md (modified)

QA Context Detected:
Issues being addressed:
- QA-013: "Timer completion sound on iOS 9"
  Status: Fixed → Verified
  Related: timer.js, play.js

- QA-014: "Layout breaking on narrow screens"
  Status: Open → Fixed
  Related: mobile.css, layout.css

Commit Message:
fix: Mobile audio and layout issues (QA-013, QA-014)

QA-013 - Timer completion sound on iOS 9:
- timer.js: Rewrote audio system with Web Audio API
- play.js: Added gesture handlers for audio init

QA-014 - Layout breaking on narrow screens:
- mobile.css: Added responsive breakpoints below 320px
- layout.css: Fixed flexbox wrapping behavior

Updated QA-TESTING.md with verification status for both issues.

[Ask: Accept / Edit / Regenerate?]

Committing...
[9ab0cd1] fix: Mobile audio and layout issues (QA-013, QA-014)
```
