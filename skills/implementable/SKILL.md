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

### 5. Context Management
- Does the plan avoid requiring recall of many detailed instructions simultaneously?
- Are related changes grouped together logically?
- Is information organised so relevant context can be provided per-task?

### 6. Supporting Infrastructure
- Is there a CLAUDE.md or similar quick-reference file with critical rules?
- Is there workflow documentation explaining how to use the plans with Claude Code?
- Are plans split across multiple files to enable focused sessions?
- Is there guidance on session management (when to /clear, how to scope work)?
- For projects with manual testing: Is there a QA tracking document?

### 7. Manual Testing & QA Workflow (when applicable)

Only evaluate this criterion when the plan involves manual testing phases (UI/UX work, multi-device support, browser compatibility, accessibility testing, or any "test on real device" tasks).

- Does the plan address how manual testing issues will be tracked and prioritised?
- Is there a structure for batching QA fixes into focused sessions?
- **Is there a research phase before defining fixes?** (to ensure fixes respect existing patterns)
- Are verification criteria defined for confirming fixes work on target devices?
- For multi-platform projects: Is there device/browser-specific test coverage planned?
- Does the workflow include: test → log → **research** → fix → verify?

## Common Problems to Flag

- **Monolithic tasks**: Single tasks that span multiple unrelated concerns
- **Implicit dependencies**: Features that assume other work is complete without stating it
- **Deferred foundations**: Core architecture decisions pushed to later phases
- **Missing verification steps**: No tests or checks between implementation stages
- **Overloaded scope**: Too many requirements packed into individual tasks
- **Unstructured QA phase**: Manual testing mentioned but no system for tracking and fixing issues iteratively
- **Missing verification loop**: No clear path from fix → deploy → verify → mark complete
- **QA as afterthought**: Testing planned for "the end" without structure for handling discoveries
- **Fix without research**: QA issues go straight to implementation without investigating existing patterns first (leads to architecturally inconsistent fixes)

## Instructions

1. **Search for the full planning ecosystem**, not just a single file:
   - Look for workflow/process guides (WORKFLOW.md, CONTRIBUTING.md)
   - Look for quick reference files (CLAUDE.md, claude.md)
   - Check if plans are deliberately split across multiple files (this is a positive pattern)
   - Check for a plans/ or docs/ directory
   - Look for QA tracking documents (QA-TESTING.md, QA.md, or similar)

2. **Evaluate the system as a whole**:
   - Multiple plan files = deliberate splitting (credit this as a strength)
   - Workflow guides that explain session management = strong context management
   - Quick reference files = good guardrails
   - QA tracking documents = mature approach to manual testing phases

3. Evaluate against each criterion above (criteria 1-6 always; criterion 7 when manual testing is involved)

4. **Calibrate to project complexity** - a complex app with multiple frontends WILL have larger phases; focus on whether phases are actionable, not just small

5. **Distinguish deliberate choices from oversights** - "TBD" items may be realistic acknowledgment of unknowns, not planning failures

6. Identify specific problems using the "Common Problems" patterns

7. Provide your assessment in the format below

## Output Format

Provide your assessment as:

### Planning Ecosystem Found
List what you discovered:
- Plan files found (and whether deliberately split)
- Supporting docs (CLAUDE.md, WORKFLOW.md, etc.)
- Quick reference materials
- QA tracking documents (if applicable)

### Overall Rating
Is this plan implementable with Claude Code?
- **Implementable**: Ready to implement with minor tweaks
- **Needs Work**: Implementable after addressing specific issues
- **Not Yet Implementable**: Fundamental changes needed first

### Strengths
What aspects of the plan work well? Credit deliberate architectural choices.

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
4. **Testing Rounds Log** - Record what was tested, when, on which devices
5. **Pending Tests** - Track areas not yet covered

**Recommended workflow (4 distinct phases):**

1. **Test & Log** - Find issues on device, record with ID, summary, screenshots
2. **Research** - For each issue, investigate before defining the fix:
   - How does existing code handle similar features?
   - What does the design (Figma/mockups) specify?
   - What patterns are already established in the codebase?
3. **Plan & Fix** - Define tasks based on research, implement in focused session
   - Use `/clear` between sessions for fresh context
   - Reference session ID when implementing ("implement QA-A")
4. **Verify** - Test fix on target devices before marking complete

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
1. Test fix on target device
2. Update issue status (Fixed/Verified/Won't Fix)
3. Run `/clear`
4. Start next session or log new issues discovered
```

This gives users the same guided workflow they have for implementation - clear prompts to start each session, explicit /clear points, and a defined iteration loop.

**Why research matters:**
Without researching existing patterns first, fixes may technically work but violate codebase architecture (e.g., adding a bottom nav when the app uses a top bar, or creating a new component when one already exists). The research phase ensures fixes fit the established patterns.

**Why this matters:**
Some projects need one QA session at the end. Projects with multiple frontends, device targets, or browser compatibility requirements may need several QA rounds throughout development. The key is having structure to prevent QA from becoming chaotic late-stage whack-a-mole.
