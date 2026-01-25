---
name: implementable
description: Check if your implementation plan will succeed with Claude Code. Evaluates whether phases fit context windows and follow iterative patterns for session-based development.
allowed-tools: Read Glob Grep
---

# Is Your Plan Implementable?

Check if your implementation plan will succeed when executed with Claude Code's session-based workflow.

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
- **Coverage verification**: Plan should include how coverage will be measured (e.g., `jest --coverage`, `pytest --cov`, `go test -cover`)

**Detecting project layers:**
- Frontend indicators: `package.json` with React/Vue/Angular/Svelte, `src/components/`, `.tsx`/`.jsx` files, `app/` or `pages/` directories
- Backend indicators: `server/`, `api/`, `routes/`, Go/Python/Ruby/Java server code, database models
- Full-stack: Both indicators present = both layers need tests

### 5. Context Management
- Does the plan avoid requiring recall of many detailed instructions simultaneously?
- Are related changes grouped together logically?
- Is information organised so relevant context can be provided per-task?

### 6. Supporting Infrastructure
- Is there a CLAUDE.md or similar quick-reference file with critical rules?
- Does CLAUDE.md include code quality gates? (e.g., max cyclomatic complexity per function, max file size, coverage thresholds)
- Is there workflow documentation explaining how to use the plans with Claude Code?
- Are plans split across multiple files to enable focused sessions?
  - For multi-phase projects (5+ phases): Are phases in separate PHASE-N-NAME.md files?
- Is there guidance on session management (when to /clear, how to scope work)?
- For projects with manual testing: Is there a QA tracking document?
- For projects with security tooling: Does the plan verify tools actually execute? (not just configure them)
- For projects with relaxed linter configs: Is there a plan to enforce standards (CI-only strict mode, tasks to fix violations, or documented justification for exceptions)?
- For projects with linters in CI: Are warnings configured to fail the build? (e.g., `--max-warnings=0` for ESLint)

### 7. Manual Testing & QA Workflow (when applicable)

Only evaluate this criterion when the plan involves manual testing phases (UI/UX work, multi-device support, browser compatibility, accessibility testing, or any "test on real device" tasks).

- Does the plan address how manual testing issues will be tracked and prioritised?
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
OPEN → IN PROGRESS → READY TO TEST → DONE
                          ↑___________|
                         (test failure)
```

**Evaluate:**
- Do phases and sessions have status tracking?
- Are states initialized (new items start OPEN)?
- Is there a verification path (READY TO TEST → DONE)?
- Is state updated as work progresses?

## Common Problems to Flag

- **Monolithic tasks**: Single tasks that span multiple unrelated concerns
- **Implicit dependencies**: Features that assume other work is complete without stating it
- **Deferred foundations**: Core architecture decisions pushed to later phases
- **Missing verification steps**: No tests or checks between implementation stages
- **Overloaded scope**: Too many requirements packed into individual tasks
- **Monolithic phase document**: Single file containing 5+ distinct phases (should be split for better navigation and context management)
- **Unstructured QA phase**: Manual testing mentioned but no system for tracking and fixing issues iteratively
- **Missing verification loop**: No clear path from fix → deploy → verify → mark complete
- **QA as afterthought**: Testing planned for "the end" without structure for handling discoveries
- **Fix without research**: QA issues go straight to implementation without investigating existing patterns first (leads to architecturally inconsistent fixes)
- **Monolithic QA document**: Single QA file with dozens of issues spanning multiple platforms, testing rounds, or concerns (context overload for focused fix sessions)
- **Monolithic implementation files**: Large files (300+ lines) that inline logic instead of extracting to separate modules. Low duplication scores can be misleading - if all the code is in one massive file, there's nothing to duplicate. Common in UI screens with inline sections/tabs, API handlers with repeated error patterns, or service files with embedded validation.
- **No coverage target**: Plan lacks any test coverage goal (should be minimum 10%)
- **Deferred testing**: Tests scheduled as a separate later session instead of being part of each feature's completion criteria (leads to superficial tests that mock at too high a level)
- **Missing layer tests**: Full-stack project with tests only on backend OR only on frontend (both layers need coverage)
- **Zero frontend tests**: Frontend code exists but no test files for components, interactions, or state
- **Zero backend tests**: Backend/API code exists but no test files for endpoints, logic, or data operations
- **Vague testing scope**: Testing tasks describe categories ("write unit tests", "add frontend tests") rather than naming specific files or components. Results in partial coverage based on implementer interpretation
- **No coverage measurement**: Tests exist but plan doesn't specify how to measure/verify coverage
- **No state tracking**: Phases and sessions lack status indicators, making progress invisible
- **Stale states**: Status fields exist but haven't been updated (items stuck IN PROGRESS)
- **Missing verification path**: No criteria for moving READY TO TEST to DONE
- **Inconsistent states**: Different terminology across documents (Fixed vs Complete vs Done)
- **Missing code quality gates**: No complexity limits, file size limits, or other quality constraints in CLAUDE.md to catch problems at planning time
- **Unverified security tooling**: Security scanners configured in CI but never verified to execute (e.g., pip-audit referenced but not installed in container, SAST tools that silently fail)
- **Partial security coverage**: Security scanning that only covers some package managers or some layers (frontend-only npm audit when backend exists, no SAST when handling sensitive data)
- **Linter rules disabled without enforcement plan**: Lint rules ignored "for gradual adoption" or "fix incrementally" but no plan to actually enforce them (no CI-only strict mode, no tasks to fix violations, no inline suppressions with justification). Leads to permanently relaxed standards.
- **Linter warnings allowed to pass CI**: Linters configured to run in CI but warnings don't fail the build (ESLint without `--max-warnings=0`, Ruff without `--exit-non-zero-on-fix`). Warnings accumulate because there's no enforcement mechanism.

## Instructions

**IMPORTANT**: When searching for files, remember that Linux filesystems are case-sensitive. When instructions list multiple variants (e.g., "CLAUDE.md, claude.md"), you MUST search for each variant separately. Don't assume finding one means the other doesn't exist.

1. **Search for the full planning ecosystem**, not just a single file:
   - Look for workflow/process guides (WORKFLOW.md, CONTRIBUTING.md)
   - Look for quick reference files (CLAUDE.md, claude.md)
   - Check if plans are deliberately split across multiple files (this is a positive pattern)
   - Check for a plans/ or docs/ directory
   - Look for QA tracking documents (QA-TESTING.md, QA.md, or similar)
   - Check if QA documents are split when appropriate (QA-001.md, QA-MOBILE.md, etc.)

2. **Detect project layers and test coverage:**
   - Identify if project has frontend code: Look for `package.json`, `src/components/`, `.tsx`/`.jsx`/`.vue` files, frontend frameworks
   - Identify if project has backend code: Look for `server/`, `api/`, `routes/`, Go/Python/Ruby/Java server code
   - Check for existing tests in each layer:
     - Look for test directories: `tests/`, `test/`, `__tests__/`, `spec/`, `e2e/`
     - Look for test files: `*.test.*`, `*.spec.*`, `*_test.*`, `test_*.*`
     - Check for test frameworks: `cypress/`, `playwright/`, `jest.config.*`, `pytest.ini`, `phpunit.xml`
   - Note any layer with zero test coverage—this is a critical gap to flag

3. **Evaluate the system as a whole**:
   - Multiple plan files = deliberate splitting (credit this as a strength)
   - Separate PHASE-N-NAME.md files for multi-phase projects = excellent navigation and context management
   - Multiple QA files (when warranted by size/complexity) = same strength
   - Workflow guides that explain session management = strong context management
   - Quick reference files = good guardrails
   - QA tracking documents = mature approach to manual testing phases

4. Evaluate against each criterion above (criteria 1-6 and 8 always; criterion 7 when manual testing is involved)

5. **Calibrate to project complexity** - a complex app with multiple frontends WILL have larger phases; focus on whether phases are actionable, not just small

6. **Distinguish deliberate choices from oversights** - "TBD" items may be realistic acknowledgment of unknowns, not planning failures

7. Identify specific problems using the "Common Problems" patterns

8. Provide your assessment in the format below

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

### Recommended Changes
Concrete suggestions to improve the plan. Keep recommendations proportionate - don't suggest splitting already-split plans further without good reason. Focus on:
- Missing supporting infrastructure
- Unclear task definitions
- Dependency issues
- Gaps in verification/testing
- Phase document splitting (when single file contains 5+ distinct phases)
- QA document splitting (when single file has 30+ issues or spans multiple platforms/concerns)

**When to split implementation plans into separate PHASE files:**

Just like QA documents, implementation plans should be split when they become too large for effective context management and navigation.

**Single file with detailed phases (1-4 phases):**
- Single `BUILD-PHASES.md` or `IMPLEMENTATION.md` is appropriate
- Detail the first phase fully, preview later phases
- Keep all phases in one document for easy reference

**Multiple PHASE files (5+ phases):**
- Split into separate files: `PHASE-1-FOUNDATION.md`, `PHASE-2-SCRAPING.md`, `PHASE-3-FRONTEND.md`, etc.
- Each file contains that phase's tasks, session scope, acceptance criteria
- Maintain consistent structure across all PHASE files
- Name files descriptively (use phase purpose in filename, not just numbers)

**Benefits of splitting phases:**
- **Easier navigation** - Jump directly to relevant phase without scrolling
- **Clearer boundaries** - Each phase is self-contained and focused
- **Better git history** - Changes to one phase don't clutter another's history
- **Parallel work** - Different sessions can reference different phase files
- **Reduced cognitive load** - Clear file structure communicates project organization
- **Consistent with "land and expand"** - Detail current phase, outline future phases

**How to split:**
1. Create `plans/` directory if it doesn't exist
2. Extract each phase into `plans/PHASE-N-NAME.md` (e.g., `PHASE-1-FOUNDATION.md`)
3. Include in each PHASE file:
   - **Phase status header** (e.g., `> **Status:** [OPEN]`)
   - Session Scope table **with Status column** using `[OPEN]`/`[IN PROGRESS]`/`[READY TO TEST]`/`[DONE]`
   - Task checklist with clear acceptance criteria
   - Tech stack or models specific to this phase
   - Cross-references to supporting docs (CLAUDE.md, WORKFLOW.md)
   - **State transition notes** explaining when sessions move between states
4. Keep master PLANNING.md with:
   - Project overview and architecture
   - Overall tech stack
   - Cross-cutting concerns
   - Reference to all PHASE files

**When evaluating existing plans:**
- Single file with 1-4 phases = fine
- Single file with 5+ phases = recommend splitting into separate PHASE-N files
- Already split into separate PHASE files = credit as a strength
- BUILD-PHASES.md with one detailed phase + previews = suggest splitting when phase 2 begins

**Example recommendation:**
> "This plan contains 9 distinct phases in a single 2,500-line file. Recommend splitting into separate files: `plans/PHASE-1-FOUNDATION.md`, `plans/PHASE-2-SCRAPING.md`, through `plans/PHASE-9-POLISH.md`. Keep the first phase fully detailed using the patterns already established, and outline later phases to be detailed as they're approached. This improves navigation and enables focused context loading for each phase."

### QA Workflow Assessment (when applicable)

Only include this section when the plan involves manual testing phases.

**Important:** Tailor all recommendations to the specific project's platforms, terminology, and architecture. Use the project's naming conventions, reference its specific target devices/browsers, and align with patterns found in its existing planning documents.

**Triggers to look for:**
- UI/UX implementation work
- Multi-device or multi-browser targets
- "Test on real device" or "manual testing" mentioned
- Legacy browser/platform support
- Accessibility testing requirements

**If QA structure is missing, recommend:**

A QA tracking document (e.g., QA-TESTING.md) with:
1. **Issue Log Table** - Quick reference with ID, summary, status, session assignment
2. **Session Scope** - Group related issues into focused fix sessions (QA-A, QA-B, etc.)
3. **Detailed Session Plans** - For each session:
   - Problem description + screenshots
   - **Research findings** (existing patterns, design intent, architectural constraints)
   - Tasks (informed by research)
   - Verification criteria
   - Deployment verification steps (how to confirm fix is live)
4. **Testing Rounds Log** - Record what was tested, when, on which devices
5. **Pending Tests** - Track areas not yet covered

**When to split QA documents:**

Just like implementation plans, QA documents should be split when they become too large for effective context management. Apply the same "deliberate splitting" pattern:

**Small projects (1-15 issues):**
- Single `QA-TESTING.md` file is appropriate
- Keep all sessions in one document for easy reference

**Medium projects (15-40 issues, or multiple testing rounds):**
- `QA-TESTING.md` - Master index with issue log table, workflow instructions, and status tracking
- `QA-001.md`, `QA-002.md`, `QA-003.md` - Split by testing round or batch
- Each numbered file contains detailed session plans for that batch

**Individual QA Issue Template:**

For medium projects using individual issue files, each `QA-{N}.md` should follow this structure:

````markdown
# QA-{N}: {Short Title}

> **Status:** [OPEN]
> **Priority:** {Low/Medium/High/Critical}
> **Affects:** {Components/views/platforms}
> **Reported:** {date}
> **Last Updated:** {date}

## Problem

{Clear description of what's wrong or broken. Include screenshots, error messages, or reproduction steps.}

## Research

{Investigation findings before implementing a fix:}
- How does existing code handle similar scenarios?
- What patterns are established in the codebase?
- What does the design specify (if applicable)?

## Resolution

{Once fixed, document:}
- What was changed and why
- Commit reference: `{commit-hash}`
- Any trade-offs or decisions made

## Verification

{How to confirm the fix works:}
- Steps to reproduce the original issue
- Expected behavior after fix
- Platforms/browsers to test on
````

**State transitions for individual issues:**
```
[OPEN] → [IN PROGRESS] → [READY TO TEST] → [DONE]
                              ↑___________|
                             (test failure)
```

- `[OPEN]` - Issue logged, not started
- `[IN PROGRESS]` - Research or fix underway
- `[READY TO TEST]` - Code committed, awaiting verification
- `[DONE]` - Verified working
- `[CLOSED]` - Won't fix / out of scope / duplicate

**Large projects (40+ issues, or multiple platforms/concerns):**
- `QA-TESTING.md` - Master index with overall status and workflow
- `QA-MOBILE.md`, `QA-DESKTOP.md`, `QA-BROWSER-COMPAT.md` - Split by platform/concern
- Or: `QA-ROUND-1.md`, `QA-ROUND-2.md`, `QA-ROUND-3.md` - Split by testing phase
- Choose split strategy based on natural boundaries in the testing work

**Why split?**
- **Context efficiency**: Loading 50 issues for a single mobile fix wastes context
- **Focused sessions**: "Read QA-MOBILE.md and fix QA-M-003" vs "Read all QA and find mobile issue 23"
- **Parallel work**: Different team members can work on different QA files simultaneously
- **Consistency**: Same "multiple files = strength" principle that applies to implementation plans

**When evaluating existing QA docs:**
- Single file with 10 issues = fine
- Single file with 30+ issues across multiple platforms = recommend splitting
- Single file with 20 issues but all related (e.g., all Safari bugs) = probably fine
- Multiple testing rounds planned = proactively recommend split structure

**Recommended workflow (4 distinct phases):**

1. **Test & Log** - Find issues on device, record with ID, summary, screenshots
2. **Research** - For each issue, investigate before defining the fix:
   - How does existing code handle similar features?
   - What does the design (Figma/mockups) specify?
   - What patterns are already established in the codebase?
3. **Plan & Fix** - Define tasks based on research, implement in focused session
   - Use `/clear` between sessions for fresh context
   - Reference session ID when implementing ("implement QA-A")
4. **Verify** - Confirm deployment, then test:
   - Ensure build/deploy completed successfully
   - Clear caches (hard refresh, clear service worker, invalidate CDN if applicable)
   - Confirm the fix is actually live (check version, console log, or changed element)
   - Test on target devices

**Session prompts for QA workflow:**

The QA tracking document should include ready-to-use prompts, just like implementation phases. Example:

```
## How to Run QA Sessions

### Starting a Research Session
> Read QA-TESTING.md and research QA-A. Investigate how the existing
> codebase handles [issue area]. Check Figma for design intent.
> Update the Research Findings section with what you discover.

### Starting a Fix Session
> Read QA-TESTING.md and implement the fix for QA-A. Follow the
> tasks defined in the session plan. The research findings show
> the patterns to follow.

### After Each Session
1. Confirm fix is deployed (build succeeded, no errors)
2. Clear caches (hard refresh, service worker, CDN)
3. Verify new code is running (check a changed element or version)
4. Test fix on target device
5. Update issue status ([READY TO TEST]/[DONE]/[CLOSED])
6. Run `/clear`
7. Start next session or log new issues discovered
```

This gives users the same guided workflow they have for implementation - clear prompts to start each session, explicit /clear points, and a defined iteration loop.

**Why research matters:**
Without researching existing patterns first, fixes may technically work but violate codebase architecture (e.g., adding a bottom nav when the app uses a top bar, or creating a new component when one already exists). The research phase ensures fixes fit the established patterns.

**Why this matters:**
Some projects need one QA session at the end. Projects with multiple frontends, device targets, or browser compatibility requirements may need several QA rounds throughout development. The key is having structure to prevent QA from becoming chaotic late-stage whack-a-mole.

---

## State Management Instructions for Claude

When implementing plans with state tracking, follow these practices:

### Before Starting Work

1. **Check current state** - Read phase/session tables to identify what's OPEN or IN PROGRESS
2. **Verify no conflicts** - Only one session should be IN PROGRESS at a time
3. **Report state change** - Tell the user: "Starting Session 2.3 `[OPEN]` → `[IN PROGRESS]`"

### During Work

1. **Update state immediately** when starting:
   ```markdown
   | 2.3 | API endpoints | [IN PROGRESS] | Started 2024-01-15 |
   ```

2. **Use TodoWrite** to track session tasks:
   - Create todos for each task in the session
   - Mark todos in_progress/completed as you work
   - Session stays IN PROGRESS until all todos complete

3. **Atomic commits** - Commit meaningful changes before updating state

### Completing Work

1. **Mark READY TO TEST** when implementation complete:
   ```markdown
   | 2.3 | API endpoints | [READY TO TEST] | Implementation complete |
   ```

2. **Provide verification instructions** - How to test, expected outcomes

3. **Wait for verification** before marking DONE:
   - User confirms working → Update to `[DONE]`
   - Issues found → Update to `[IN PROGRESS]`, create fix tasks

### State Update Format

Report state changes clearly:
```
State Update:
- Phase 2: [IN PROGRESS] → [READY TO TEST]
- Session 2.3: [IN PROGRESS] → [READY TO TEST]
```

### TodoWrite Coordination

| Session State | TodoWrite State |
|---------------|-----------------|
| OPEN | No todos created |
| IN PROGRESS | Has pending/in_progress todos |
| READY TO TEST | All todos completed |
| DONE | Session verified |

---

## QA Round Detection and Creation

When evaluating plans OR when explicitly requested, detect completed work needing QA and create feature-scoped QA tracking documents.

### When Evaluating Plans: Detect and Recommend

Look for:
- Tasks marked `[x]` (completed)
- Session status showing ✓ or "complete"
- UI/UX features, multi-platform work, or acceptance criteria needing verification

When detected, include in assessment:

```markdown
### QA Rounds Recommended

Based on completed work, consider creating QA rounds for:

1. **QA Round {N}: {Feature Name}**
   - Scope: {Brief summary of what was implemented}
   - Features: {Key testable items}
   - Command: `use implementable skill to create QA Round {N} for {Feature}`
```

### When Creating: Generate QA Round Documents

**Trigger phrases:**
- "create QA Round {N} for {Feature}"
- "start QA for {Feature}"
- "set up QA testing for {Feature}"

This is a **CREATION REQUEST**, not evaluation.

**Workflow:**
1. Search for existing `QA-ROUND-*.md` files to determine next round number
2. Read implementation plan to extract features, acceptance criteria, and platforms
3. Generate round document using project's terminology and patterns
4. Name as: `QA-ROUND-{N}-{FEATURE-SLUG}.md` (or adapt to project's naming convention)
5. Place in project's QA documentation location (commonly `plans/` or `docs/`)

**Document structure to generate:**

````markdown
# QA Round {N}: {Feature Name}

> **Scope:** {Brief description}
> **Phase:** {Phase/sessions that implemented this}
> **Platforms:** {Relevant platforms/devices}
> **Created:** {Current date}

## Overview

{Describe what was implemented and needs testing}

**Features to test:**
- {Feature 1}
- {Feature 2}

**Testing focus:**
- {Platform-specific areas}

## Issue Log

| ID | Summary | Affects | Status | Session |
|----|---------|---------|--------|---------|

### Status Key
- **[OPEN]** - Logged, not yet started
- **[IN PROGRESS]** - Actively being researched or fixed
- **[READY TO TEST]** - Code changed, awaiting verification
- **[DONE]** - Verified working on target platforms
- **[CLOSED]** - Won't fix, out of scope, or deferred

### State Transitions
- Issue discovered: → `[OPEN]`
- Research/fix started: `[OPEN]` → `[IN PROGRESS]`
- Code committed: `[IN PROGRESS]` → `[READY TO TEST]`
- Verification passed: `[READY TO TEST]` → `[DONE]`
- Test failed: `[READY TO TEST]` → `[IN PROGRESS]`
- Out of scope: Any → `[CLOSED]`

## Test Scenarios

{Generate scenarios based on acceptance criteria from implementation plan}

### {Platform/Area 1}
- [ ] {Scenario from implementation}

### {Platform/Area 2}
- [ ] {Scenario from implementation}

## Session Scope

{Empty initially - populated as issues are found}

| Session | Issue(s) | Status | Focus |
|---------|----------|--------|-------|
| QA-{RND}-A | | [OPEN] | |

## How to Run Sessions

### Starting a Research Session
```
Read plans/QA-ROUND-{N}-{FEATURE}.md and research QA-{RND}-A.
Investigate existing patterns. Update Research Findings.
```

### Starting a Fix Session
```
Read plans/QA-ROUND-{N}-{FEATURE}.md and implement QA-{RND}-A.
Follow the tasks defined in the session plan.
```

### After Each Session
1. Confirm deployment
2. Clear caches
3. Verify fix is live
4. Test on target devices
5. Update status
6. `/clear` and continue

## Fix Sessions

{Sessions added as issues are found}

## Round Completion

- [ ] All test scenarios completed
- [ ] All issues logged and fixed
- [ ] All fixes verified

**Round Status:** [OPEN]
**Progress:** 0/0 issues resolved
**Last Updated:** {date}
````

**Population guidelines:**
1. **Extract from implementation plan:** Feature names, sessions/phases, acceptance criteria, target platforms
2. **Generate test scenarios from:** Acceptance criteria, feature descriptions, expected behaviors
3. **Use project's patterns:** Match their terminology, status values, session naming
4. **Keep focused:** One round per feature or tightly-related feature group
