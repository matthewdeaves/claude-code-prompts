---
name: checking-implementability
description: Check if your implementation plan will succeed with Claude Code. Evaluates whether phases fit context windows and follow iterative patterns for session-based development.
allowed-tools: Read Glob Grep Task
---

# Checking Implementability

Check if your implementation plan will succeed when executed with Claude Code's session-based workflow.

## Contents
- [Core Principle](#core-principle-land-and-expand)
- [Evaluation Criteria](#what-makes-a-plan-implementable)
- [Instructions](#instructions)
- [Output Format](#output-format)
- [QA Workflow Assessment](#qa-workflow-assessment-when-applicable)

## Core Principle: Land and Expand

Effective plans follow an iterative "Land and Expand" pattern:
- **Land**: Define and implement a minimal working core with clean architecture and clear patterns
- **Expand**: Add features layer by layer, each building on the established foundation

## What Makes a Plan Implementable?

### 1. Task Granularity
- Is there a clearly defined minimal core to implement first?
- Are features broken into discrete, focused tasks?
- Can each task be completed independently without requiring extensive context?
- Does each task touch a reasonable number of files (ideally fewer than 5-10)?

### 2. Dependency Structure
- Are foundational components identified and scheduled before dependent features?
- Are there circular dependencies that would force incomplete implementations?
- Can each task produce working, testable code before moving to the next?

### 3. Instruction Clarity
- Is each task specific enough to act on without ambiguity?
- Are success criteria defined for each task?
- Are constraints and requirements stated explicitly rather than implied?

### 4. Testability
- Does the plan include test creation alongside or before implementation?
- Can each increment be verified before proceeding?
- Are acceptance criteria concrete and measurable?
- **Does each session include verification as a completion criterion?** Tests should not be a separate "write tests" task scheduled for later - they should be part of completing each feature.

**Session Verification Pattern:**
Sessions that defer testing create coverage gaps. Compare:

```markdown
# Good: Verification built into each session
| Session | Tasks | Verify |
| A | User model | pytest tests/test_models.py passes |
| B | Auth endpoints | pytest tests/test_auth.py passes |

# Bad: Tests deferred to separate session
| Session | Tasks |
| A | Feature X: Backend + UI |
| B | Feature Y: Backend + UI |
| F | Write tests for all features |  ← Context gone, tests become superficial
```

When tests are written in the same session as implementation, the developer has full context of edge cases and error paths. When deferred, tests mock at too high a level because the implementer no longer remembers the details.

**Test Coverage Requirements:**
- **Minimum 10% coverage target**: Plans must establish a baseline coverage goal of at least 10%. This is a floor, not a ceiling—mature projects should aim higher.
- **Layer coverage**: If the project has both frontend and backend code, tests MUST exist for both layers. Zero tests in any layer is unacceptable.
  - Backend tests: API endpoints, business logic, data validation, database operations
  - Frontend tests: Component rendering, user interactions, state management, integration with backend
- **Name what to test**: Testing tasks that describe categories ("write frontend tests", "test the API layer") leave coverage to interpretation. Tasks should name specific targets: "test user profile page: loading state, error handling, form submission" not "write UI tests". When a task builds something, the testing task should name that thing.
- **Coverage verification**: Plan should include how coverage will be measured using language-appropriate tools

**Detecting project layers:**
- Frontend indicators: Frontend framework dependencies, component directories, JSX/TSX files, page/route structures
- Backend indicators: Server directories, API routes, database models, service layers
- Full-stack: Both indicators present = both layers need tests

### 5. Context Management
- Does the plan avoid requiring recall of many detailed instructions simultaneously?
- Are related changes grouped together logically?
- Is information organized so relevant context can be provided per-task?

### 6. Supporting Infrastructure
- Is there a CLAUDE.md or similar quick-reference file with critical rules?
- Does CLAUDE.md include code quality gates? (e.g., max cyclomatic complexity per function, max file size, coverage thresholds)
- Is there workflow documentation explaining how to use the plans with Claude Code?
- Are plans split across multiple files to enable focused sessions? (See [Document Splitting](#document-splitting-principles))
- Is there guidance on session management (when to /clear, how to scope work)?
- For projects with manual testing: Is there a QA tracking document?
- For projects with dependencies: Does the plan include dependency vulnerability scanning in CI using language-appropriate tools?
- For projects with security tooling: Does the plan verify tools actually execute? (not just configure them)
- For projects with relaxed linter configs: Is there a plan to enforce standards (CI-only strict mode, tasks to fix violations, or documented justification)?
- For projects with linters in CI: Are warnings configured to fail the build?
- For projects with CI workflows: Are substantial scripts (>50-100 lines) embedded in config files or extracted to testable files?
  - **Why this matters**: Embedding code in CI config files makes debugging impossible and prevents local execution. Extract to separate script files for maintainability.
  - **Detection**: Scan CI config files for heredocs or inline scripts exceeding ~50-100 lines
  - **Suggest**: "Extract scripts to `.github/scripts/` (or `scripts/`, `ci/`) for local testing and maintainability"
- For projects with test suites but no CI: Does the plan include running tests automatically?
  - **Detection**: Test files/config exist but no CI config files
  - **Suggest**: "Consider adding CI to run tests on every commit (prevents regressions)" - keep generic, don't prescribe platforms
  - **Skip**: If project is explicitly a prototype or single-developer tool
- For multi-screen applications: Does the plan specify navigation/routing architecture?
  - **Why this matters**: Multi-screen apps need proper navigation structure. Server-rendered frameworks have built-in routing and can skip this check.
  - **Detection**: Plans creating multiple screen/page components without mentioning navigation
  - **Suggest**: Specify navigation architecture (without prescribing specific libraries)
  - **Skip**: Server-rendered apps where framework provides routing

### 7. Manual Testing & QA Workflow (when applicable)

Only evaluate this criterion when the plan involves manual testing phases (UI/UX work, multi-device support, browser compatibility, accessibility testing, or any "test on real device" tasks).

- Does the plan address how manual testing issues will be tracked and prioritized?
- Is there a structure for batching QA fixes into focused sessions?
- **Is there a research phase before defining fixes?** (to ensure fixes respect existing patterns)
- Are verification criteria defined for confirming fixes work on target devices?
- For multi-platform projects: Is there device/browser-specific test coverage planned?
- Does the workflow include: test → log → **research** → fix → verify?

### 8. State Management

Plans should track state at multiple levels for progress visibility:

**State Hierarchy:**
- **Phases** - High-level project milestones
- **Sessions** - Focused work units within phases
- **QA Issues** - Individual problems discovered during testing

**Unified States:**
| State | Meaning |
|-------|---------|
| `[OPEN]` | Not started |
| `[IN PROGRESS]` | Currently being worked on |
| `[READY TO TEST]` | Implementation complete, awaiting verification |
| `[DONE]` | Verified and complete |
| `[CLOSED]` | Won't fix / out of scope (QA issues only) |

**State Transitions:**
```
[OPEN] → [IN PROGRESS] → [READY TO TEST] → [DONE]
                              ↑___________|
                             (test failure)
```

**Evaluate:**
- Do phases and sessions have status tracking?
- Are states initialized (new items start OPEN)?
- Is there a verification path (READY TO TEST → DONE)?
- Is state updated as work progresses?

### 9. Architectural Patterns

- **Monolithic implementation files**: Large files (300+ lines) that inline logic instead of extracting to separate modules. Low duplication scores can be misleading if all code is in one massive file.
- **No refactoring step after repetitive implementation**: Plans that create multiple similar components (5+ API endpoints, view handlers, or service methods) without including a refactoring task to extract shared patterns. After implementing similar features, plans should include a task to identify and extract common patterns into helpers or base classes.
- **No shared utilities infrastructure**: Plans that create multiple similar modules (4+ page files, screens, services, or API handlers) without defining shared utility functions first. Before building consuming modules, plans should create shared utility infrastructure. Don't create utilities speculatively, but do create them when 4+ modules will obviously share the same functions.

## Document Splitting Principles

Just as code should be modular, planning documents should be split when they become too large for effective navigation and context management.

**General Pattern:**

| Document Type | Small Scale | Medium Scale | Large Scale |
|---------------|-------------|--------------|-------------|
| **Implementation Plans** | Single file (1-4 phases) | Separate PHASE files (5+ phases) | Categorized PHASE files |
| **QA Documents** | Single file (1-15 issues) | Numbered QA rounds (15-40 issues) | Platform/concern split (40+) |

### Splitting Implementation Plans

**Single file (1-4 phases):**
- `BUILD-PHASES.md` or `IMPLEMENTATION.md` is appropriate
- Keep all phases in one document for easy reference

**Separate PHASE files (5+ phases):**
- Split into: `PHASE-1-FOUNDATION.md`, `PHASE-2-SCRAPING.md`, `PHASE-3-FRONTEND.md`, etc.
- Each file is self-contained with tasks, session scope, acceptance criteria
- Name files descriptively (use phase purpose in filename, not just numbers)

**Benefits:**
- Easier navigation - jump directly to relevant phase
- Better git history - changes to one phase don't clutter another's history
- Reduced cognitive load - clear file structure communicates organization

**How to split:**
1. Create `plans/` directory
2. Extract each phase into `plans/PHASE-N-NAME.md`
3. Include in each PHASE file:
   - Phase status header (e.g., `> **Status:** [OPEN]`)
   - Session Scope table with Status column
   - Task checklist with acceptance criteria
   - Cross-references to supporting docs (CLAUDE.md, WORKFLOW.md)
4. Keep master PLANNING.md with project overview and phase references

### Splitting QA Documents

**Small projects (1-15 issues):**
- Single `QA-TESTING.md` file

**Medium projects (15-40 issues):**
- `QA-TESTING.md` - Master index
- `QA-001.md`, `QA-002.md` - Split by testing round

**Large projects (40+ issues):**
- `QA-TESTING.md` - Master index
- Split by platform: `QA-MOBILE.md`, `QA-DESKTOP.md`
- Or by round: `QA-ROUND-1.md`, `QA-ROUND-2.md`

**Why split:**
- Context efficiency: Load only relevant issues for focused fix sessions
- Parallel work: Different sessions can reference different QA files

See the `qa-round` skill for creating structured QA tracking documents.

## Instructions

### Step 1: Launch Parallel Explore Agents

**CRITICAL**: Always use parallel Explore agents to gather information. This prevents context bloat when evaluating large planning ecosystems. Launch ALL of these agents simultaneously in a single message:

| Agent | Search Target | What to Find |
|-------|---------------|--------------|
| **Find planning documents** | Plan files | BUILD-PHASES.md, IMPLEMENTATION.md, PLANNING.md, plans/*.md, PHASE-*.md |
| **Find workflow docs** | Process guides | WORKFLOW.md, CONTRIBUTING.md, CLAUDE.md, claude.md, README.md |
| **Find QA/test docs** | QA tracking | QA-TESTING.md, QA.md, QA-*.md, test plans |
| **Analyze CI/deps config** | Infrastructure | CI configs (.github/workflows, .gitlab-ci.yml), package.json, requirements.txt, go.mod, etc. Check for vulnerability scanning, embedded scripts |
| **Analyze source architecture** | Code structure | Frontend indicators (components/, pages/, JSX/TSX), backend indicators (api/, server/, routes/), test directories (tests/, __tests__/, spec/) |

**Agent prompts should be specific**. Example for planning documents agent:
> "Search for implementation plan files. Look for: BUILD-PHASES.md, IMPLEMENTATION.md, PLANNING.md, any files in plans/ directory, PHASE-*.md files. Report file paths found and summarize the structure (number of phases, whether split across files)."

**IMPORTANT**: Linux filesystems are case-sensitive. When searching for files like CLAUDE.md, agents must search for both CLAUDE.md and claude.md separately.

### Step 2: Synthesize Agent Results

Once all agents return, combine their findings to evaluate:

1. **Planning ecosystem completeness**:
   - Multiple plan files = deliberate splitting (credit as strength)
   - Separate PHASE files for multi-phase projects = excellent navigation
   - Workflow guides explaining session management = strong context management
   - Quick reference files (CLAUDE.md) = good guardrails

2. **Test coverage by layer**:
   - Full-stack projects need tests in BOTH frontend and backend
   - Zero tests in any layer = critical gap
   - Check for coverage targets in plan (minimum 10%)

3. **Infrastructure health**:
   - Dependencies exist → vulnerability scanning should exist
   - CI configs with >50-100 line embedded scripts → flag for extraction
   - Tests exist but no CI → suggest automation

4. **QA structure** (when manual testing is involved):
   - Issue tracking system present?
   - Research phase before fixes?
   - Verification criteria defined?

### Step 3: Evaluate Against Criteria

Evaluate against criteria 1-9 from the "What Makes a Plan Implementable?" section:
- Criteria 1-6, 8-9: Always evaluate
- Criterion 7 (QA Workflow): Only when manual testing is involved

### Step 4: Calibrate Assessment

- **Calibrate to project complexity** - complex apps with multiple frontends WILL have larger phases; focus on whether phases are actionable, not just small
- **Distinguish deliberate choices from oversights** - "TBD" items may be realistic acknowledgment of unknowns, not planning failures

## Output Format

Provide your assessment as:

### Planning Ecosystem Found
List what you discovered:
- Plan files found (and whether deliberately split)
- Supporting docs (CLAUDE.md, WORKFLOW.md, etc.)
- Quick reference materials
- QA tracking documents (if applicable, and whether split when appropriate)

### Overall Rating
Is this plan implementable with Claude Code?
- **Implementable**: Ready to implement with minor tweaks
- **Needs Work**: Implementable after addressing specific issues
- **Not Yet Implementable**: Fundamental changes needed first

### Strengths
What aspects of the plan work well? Credit deliberate architectural choices.

### Test Coverage Assessment
Report on the project's test coverage status:
- **Project layers detected**: Frontend only / Backend only / Full-stack
- **Frontend tests**: Present / Missing (list test files found or note absence)
- **Backend tests**: Present / Missing (list test files found or note absence)
- **Coverage target in plan**: Yes (X%) / No / Not specified
- **Coverage gaps**: Any layer with zero tests = critical issue

### Security Scanning Assessment
Report on the project's dependency vulnerability scanning:
- **Dependency files detected**: List found
- **Vulnerability scanning in CI**: Present / Missing / Partial (list which scanners found)
- **Scanner verification**: If present, does plan verify scanners execute? Yes / No / Not mentioned
- **Critical gaps**: Dependencies exist but no scanning = critical issue

### State Management Assessment
Report on the project's state tracking:
- **Phase tracking**: Present with states / Present without states / Missing
- **Session tracking**: Present with states / Present without states / Missing
- **QA issue states**: Uses unified model / Uses custom states / Missing
- **State currency**: Appears current / Appears stale / Cannot determine
- **Gaps**: List any state tracking issues

### Issues Found
Specific problems identified, referencing the criteria above. Distinguish between:
- Actual oversights that need fixing
- Deliberate trade-offs that are acceptable

Common issues to look for:
- Monolithic tasks spanning multiple unrelated concerns
- Implicit dependencies without stated requirements
- Deferred foundations (core architecture pushed to later phases)
- Missing verification steps between implementation stages
- Overloaded scope in individual tasks
- Monolithic phase documents (5+ phases in single file)
- Unstructured QA phases without issue tracking system
- Missing verification loops (no clear path from fix → verify → mark complete)
- QA as afterthought without structure for handling discoveries
- Fix without research (issues go straight to implementation without investigating patterns)
- Monolithic QA documents (30+ issues in single file)
- Monolithic implementation files (300+ lines with inline logic)
- No refactoring after repetitive implementation (5+ similar components without extraction task)
- No shared utilities infrastructure (4+ modules without common utilities)
- No coverage target (should be minimum 10%)
- Deferred testing (tests as separate later session instead of part of feature completion)
- Missing layer tests (full-stack with tests only on one layer)
- Zero frontend/backend tests
- Vague testing scope (categories instead of specific targets)
- No coverage measurement specified
- No state tracking or stale states
- Missing verification path (no READY TO TEST → DONE criteria)
- Inconsistent state terminology
- Missing code quality gates in CLAUDE.md
- No dependency vulnerability scanning
- Unverified security tooling
- Embedded CI scripts (>50-100 lines in config files)
- Tests without CI automation
- Linter rules disabled without enforcement plan
- Linter warnings allowed to pass CI

### Recommended Changes
Concrete suggestions to improve the plan. Keep recommendations proportionate - don't suggest splitting already-split plans further without good reason. Focus on:
- Missing supporting infrastructure
- Unclear task definitions
- Dependency issues
- Gaps in verification/testing
- Document splitting when appropriate (5+ phases, 30+ QA issues)

### Apply Changes Prompt

After presenting all findings above, use AskUserQuestion to offer the user options. If no issues were found, skip this prompt and inform the user the plan passed review.

```
question: "How would you like to proceed with these recommendations?"
header: "Apply"
options:
  - label: "Apply all recommendations (Recommended)"
    description: "Implement every suggestion from the review - test coverage, state tracking, document splitting, and all other changes"
  - label: "Apply critical issues only"
    description: "Fix only the most important issues: missing tests, security gaps, and blocking problems"
```

**If user selects "Apply all recommendations":** Proceed to apply every recommendation from the Issues Found and Recommended Changes sections.

**If user selects "Apply critical issues only":** Apply only items marked as critical or blocking:
- Missing test coverage for any layer
- Security scanning gaps
- Blocking dependency issues
- Missing verification paths

**If user provides custom input:** Follow their specific instructions for which changes to make.

### Applying Recommendations

When applying changes (either from user selection or explicit request):

- Make changes directly to the plan document
- Do NOT add meta-commentary sections like "Recent Updates" or "Change Log"
- Do NOT add sections explaining what you changed
- Plans should be self-documenting - let git history track revisions
- Update the plan as if it was written this way from the beginning

**Example of what NOT to do:**
```markdown
## Recent Updates
This plan has been updated based on implementability review:
1. Phase order swapped
2. State tracking added
...
```

**Why:** Meta-commentary is noise. The plan's structure should make the approach clear without explaining its revision history. If someone needs to see what changed, they can use `git diff`.

### QA Workflow Assessment (when applicable)

Only include this section when the plan involves manual testing phases.

**Important:** Tailor all recommendations to the specific project's platforms, terminology, and architecture.

**Triggers to look for:**
- UI/UX implementation work
- Multi-device or multi-browser targets
- "Test on real device" or "manual testing" mentioned
- Legacy browser/platform support
- Accessibility testing requirements

**If QA structure is missing, recommend:**

Use the `qa-round` skill to create structured QA tracking documents, or suggest a QA tracking document with:
1. **Issue Log Table** - Quick reference with ID, summary, status, session assignment
2. **Session Scope** - Group related issues into focused fix sessions
3. **Detailed Session Plans** - For each session: problem description, research findings, tasks, verification criteria
4. **Testing Rounds Log** - Record what was tested, when, on which devices
5. **Pending Tests** - Track areas not yet covered

**Recommended workflow (4 phases):**
1. **Test & Log** - Find issues, record with ID, summary, screenshots
2. **Research** - Investigate existing patterns before defining fixes
3. **Plan & Fix** - Define tasks based on research, implement in focused session
4. **Verify** - Confirm deployment, clear caches, test on target devices

**When to split QA documents:** See [Document Splitting](#document-splitting-principles) section.

**Why research matters:** Without researching existing patterns first, fixes may technically work but violate codebase architecture.

**Why this matters:** Projects with multiple frontends, device targets, or browser compatibility requirements may need several QA rounds throughout development. The key is having structure to prevent QA from becoming chaotic late-stage whack-a-mole.
