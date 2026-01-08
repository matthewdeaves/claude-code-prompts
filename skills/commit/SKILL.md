---
name: commit
description: Smart git commits with security checks, .gitignore validation, and intelligent commit messages. Analyzes your changes, catches potential secrets, and generates conventional commit messages.
allowed-tools: Bash Read Grep Glob AskUserQuestion
---

# Smart Commit

Perform intelligent pre-commit analysis, security scanning, and generate high-quality conventional commit messages.

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

Rules for the subject line:
- Use imperative mood ("Add feature" not "Added feature")
- No period at the end
- 50 characters or less
- Capitalize the first letter after the type prefix

Rules for the body:
- Wrap at 72 characters
- Explain what and why, not how
- Reference related issues if apparent from the code

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

## Example Session Flow

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

Implement login/logout functionality with session management.
Includes unit tests for auth flow.

[Ask: Accept / Edit / Regenerate?]

Committing...
[abc1234] feat: Add user authentication feature
```
