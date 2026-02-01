---
name: creating-qa-rounds
description: Create structured QA round documents for manual testing phases. Generates tracking docs with issue logging, session planning, and verification workflows.
allowed-tools: Read Glob Grep Write
---

# Creating QA Rounds

Create feature-scoped QA tracking documents for manual testing phases.

## Contents
- When to Use This Skill
- What This Skill Does
- Workflow (Determine Round, Extract Context, Generate Document, Populate Content)
- State Model (States and Transitions)
- QA Workflow Phases (Test & Log, Research, Plan & Fix, Verify)
- Document Structure
- When to Split QA Documents
- Individual Issue Files (Alternative Pattern)
- Output
- Example Generation
- Important Notes

## When to Use This Skill

Use this skill when:
- Implementation work is complete and needs manual testing
- UI/UX features need verification across devices/browsers
- A feature has acceptance criteria that require hands-on testing
- You need to organize manual testing into structured rounds

**Trigger phrases:**
- "create QA Round {N} for {Feature}"
- "start QA round for {Feature}"
- "set up QA testing for {Feature}"

## What This Skill Does

Generates a structured QA round document that includes:
1. **Issue Log Table** - Track discovered issues with IDs, status, and session assignments
2. **Test Scenarios** - Derived from implementation plan's acceptance criteria
3. **Session Scope** - Group related issues into focused fix sessions
4. **Workflow Instructions** - Ready-to-use prompts for research, fix, and verification sessions
5. **State Tracking** - Progress visibility using unified state model

## Workflow

### 1. Determine Round Number
Search for existing `QA-ROUND-*.md` files to identify the next sequential number.

### 2. Extract Testing Context
Read the implementation plan to gather:
- Features that were implemented
- Acceptance criteria and expected behaviors
- Target platforms/devices mentioned
- Phase or session IDs that completed the work

### 3. Generate Round Document
Create `QA-ROUND-{N}-{FEATURE-SLUG}.md` using the template from `skills/checking-implementability/templates/QA-ROUND-TEMPLATE.md`.

**Document naming:**
- Format: `QA-ROUND-{N}-{FEATURE-SLUG}.md`
- Example: `QA-ROUND-1-USER-AUTH.md`
- Place in project's documentation location (commonly `plans/` or `docs/`)

### 4. Populate Content

**Use project's terminology and patterns:**
- Match status terminology from existing docs
- Reference specific platforms/devices from the implementation plan
- Use session naming conventions established in the project
- Align with acceptance criteria phrasing

**Generate test scenarios from:**
- Acceptance criteria in the implementation plan
- Feature descriptions and expected behaviors
- Platform-specific requirements
- Edge cases or error conditions mentioned

**Keep focused:**
- One round per feature or tightly-related feature group
- Don't create mega-rounds spanning multiple unrelated features

## State Model

All QA rounds use this unified state model:

### States
- **[OPEN]** - Not started
- **[IN PROGRESS]** - Currently being worked on
- **[READY TO TEST]** - Implementation complete, awaiting verification
- **[DONE]** - Verified and complete
- **[CLOSED]** - Won't fix / out of scope (issues only)

### State Transitions
```
[OPEN] → [IN PROGRESS] → [READY TO TEST] → [DONE]
                              ↑___________|
                             (test failure)
```

## QA Workflow Phases

The generated document should support this 4-phase workflow:

1. **Test & Log** - Find issues on device, record with ID, summary, screenshots
2. **Research** - For each issue, investigate before defining the fix:
   - How does existing code handle similar features?
   - What does the design (Figma/mockups) specify?
   - What patterns are already established in the codebase?
3. **Plan & Fix** - Define tasks based on research, implement in focused session
   - Use `/clear` between sessions for fresh context
   - Reference session ID when implementing
4. **Verify** - Confirm deployment, then test:
   - Ensure build/deploy completed successfully
   - Clear caches (hard refresh, clear service worker, invalidate CDN)
   - Confirm the fix is actually live
   - Test on target devices

**Why research matters:** Without researching existing patterns first, fixes may technically work but violate codebase architecture (e.g., adding a bottom nav when the app uses a top bar).

## Document Structure

Use the template at `skills/checking-implementability/templates/QA-ROUND-TEMPLATE.md` with these sections:

1. **Header** - Round number, feature name, scope, platforms, dates
2. **Overview** - What was implemented, features to test, testing focus
3. **Issue Log** - Table with ID, Summary, Affects, Status, Session
4. **Test Scenarios** - Organized by platform/area with checkboxes
5. **Session Scope** - Table mapping sessions to issues
6. **How to Run Sessions** - Ready-to-use prompts
7. **Fix Sessions** - Detailed plans for each fix (populated as issues found)
8. **Round Completion** - Checklist and progress tracking

## When to Split QA Documents

**Small projects (1-15 issues):**
- Single `QA-TESTING.md` file
- Keep all sessions in one document

**Medium projects (15-40 issues, or multiple testing rounds):**
- `QA-TESTING.md` - Master index
- `QA-ROUND-1.md`, `QA-ROUND-2.md` - Split by testing round or batch
- Each numbered file contains detailed session plans

**Large projects (40+ issues, or multiple platforms):**
- `QA-TESTING.md` - Master index
- Split by platform: `QA-MOBILE.md`, `QA-DESKTOP.md`, `QA-BROWSER-COMPAT.md`
- Or by round: `QA-ROUND-1.md`, `QA-ROUND-2.md`, `QA-ROUND-3.md`

**Why split?**
- Context efficiency: Loading 50 issues for a single mobile fix wastes context
- Focused sessions: Direct prompts like "Read QA-MOBILE.md and fix QA-M-003"
- Parallel work: Different team members can work on different QA files

## Individual Issue Files (Alternative Pattern)

For medium projects, consider individual issue files instead of batch files:

**Structure:**
- `QA-TESTING.md` - Master index with issue log table
- `QA-001.md`, `QA-002.md`, `QA-003.md` - One file per issue

Use the template at `skills/checking-implementability/templates/QA-ISSUE-TEMPLATE.md` for individual issues.

## Output

After creating the QA round document, report:

```markdown
### QA Round Created

Created: `plans/QA-ROUND-{N}-{FEATURE}.md`

**Scope:** {Brief summary}
**Features to test:** {Count} test scenarios generated
**Platforms:** {List}

Next steps:
1. Begin manual testing on target platforms
2. Log issues in the Issue Log table
3. Create fix sessions as issues are discovered
4. Use provided session prompts to organize work
```

## Example Generation

If user says: "create QA Round 1 for user authentication"

1. Search: `QA-ROUND-*.md` → confirms this is round 1
2. Read: Implementation plan (e.g., `PHASE-2-AUTH.md` or `BUILD-PHASES.md`)
3. Extract:
   - Features: Login, signup, password reset, session management
   - Platforms: Web (Chrome, Safari, Firefox), iOS, Android
   - Acceptance criteria: "Users can log in with email/password", "Password reset sends email", etc.
4. Generate: `plans/QA-ROUND-1-USER-AUTH.md` with:
   - Test scenarios derived from acceptance criteria
   - Platform-specific test sections
   - Empty issue log (populated during testing)
   - Session workflow instructions

## Important Notes

- **Tailor to the project:** Use the project's terminology, platforms, and patterns
- **Don't create issues yet:** The round document provides structure; issues are logged during actual testing
- **Reference implementation work:** Link to phases/sessions that built the features being tested
- **Keep rounds focused:** One round per feature or small feature group
- **Match existing patterns:** If the project has existing QA docs, match their style and structure
