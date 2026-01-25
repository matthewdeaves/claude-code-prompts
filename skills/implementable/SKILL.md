---
name: implementable
description: Check if your implementation plan will succeed with Claude Code. Evaluates whether phases fit context windows and follow iterative patterns for session-based development.
allowed-tools: Read Glob Grep
---

# Is Your Plan Implementable?

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

**IMPORTANT**: When searching for files, remember that Linux filesystems are case-sensitive. When instructions list multiple variants (e.g., "CLAUDE.md, claude.md"), you MUST search for each variant separately.

1. **Search for the full planning ecosystem**, not just a single file:
   - Look for workflow/process guides (WORKFLOW.md, CONTRIBUTING.md)
   - Look for quick reference files (CLAUDE.md, claude.md)
   - Check if plans are deliberately split across multiple files (this is a positive pattern)
   - Check for a plans/ or docs/ directory
   - Look for QA tracking documents (QA-TESTING.md, QA.md, or similar)
   - Check if QA documents are split when appropriate

2. **Detect project layers and test coverage:**
   - Identify if project has frontend code: Look for frontend framework indicators
   - Identify if project has backend code: Look for server directories, API routes, database models
   - Check for existing tests in each layer:
     - Look for test directories: `tests/`, `test/`, `__tests__/`, `spec/`, `e2e/`
     - Look for test files with common naming patterns
     - Check for test framework configs
   - Note any layer with zero test coverage—this is a critical gap to flag

3. **Detect dependency files and security scanning:**
   - Check for dependency manifests (package.json, requirements.txt, go.mod, Gemfile, Cargo.toml, composer.json, etc.)
   - If dependency files exist, check for vulnerability scanning in CI configs
   - Flag if dependencies exist but no vulnerability scanning is configured

4. **Detect CI configuration issues:**
   - Check for CI config files in standard locations
   - If CI configs exist, scan for embedded scripts via heredocs (estimate line count)
   - Flag if any embedded script exceeds ~50-100 lines
   - Check for test suite without CI: tests exist but no CI automation
   - Skip CI suggestion if project is clearly a prototype or single-developer tool

5. **Evaluate the system as a whole**:
   - Multiple plan files = deliberate splitting (credit this as a strength)
   - Separate PHASE files for multi-phase projects = excellent navigation
   - Multiple QA files (when warranted) = same strength
   - Workflow guides that explain session management = strong context management
   - Quick reference files = good guardrails

6. Evaluate against each criterion above (criteria 1-8 always; criterion 7 when manual testing is involved)

7. **Calibrate to project complexity** - a complex app with multiple frontends WILL have larger phases; focus on whether phases are actionable, not just small

8. **Distinguish deliberate choices from oversights** - "TBD" items may be realistic acknowledgment of unknowns, not planning failures

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
