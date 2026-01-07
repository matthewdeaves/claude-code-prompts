---
name: evaluate-plan
description: Evaluate a project plan for Claude Code compatibility. Use when reviewing implementation plans, project breakdowns, or task lists to assess how well they will work with Claude Code's iterative workflow.
allowed-tools: Read Glob Grep
---

# Evaluate Plan for Claude Code Compatibility

Review the provided project plan and assess how well it will work when implemented using Claude Code.

## Core Principle: Land and Expand

Effective plans follow an iterative "Land and Expand" pattern:
- **Land**: Define and implement a minimal working core with clean architecture and clear patterns
- **Expand**: Add features layer by layer, each building on the established foundation

## Evaluation Criteria

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

## Common Problems to Flag

- **Monolithic tasks**: Single tasks that span multiple unrelated concerns
- **Implicit dependencies**: Features that assume other work is complete without stating it
- **Deferred foundations**: Core architecture decisions pushed to later phases
- **Missing verification steps**: No tests or checks between implementation stages
- **Overloaded scope**: Too many requirements packed into individual tasks

## Instructions

1. **Search for the full planning ecosystem**, not just a single file:
   - Look for workflow/process guides (WORKFLOW.md, CONTRIBUTING.md)
   - Look for quick reference files (CLAUDE.md, claude.md)
   - Check if plans are deliberately split across multiple files (this is a positive pattern)
   - Check for a plans/ or docs/ directory

2. **Evaluate the system as a whole**:
   - Multiple plan files = deliberate splitting (credit this as a strength)
   - Workflow guides that explain session management = strong context management
   - Quick reference files = good guardrails

3. Evaluate against each of the five criteria above

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

### Overall Rating
How well-suited is this plan for Claude Code implementation?
- **Good**: Ready to implement with minor tweaks
- **Needs Adjustment**: Workable but should address specific issues first
- **Major Restructuring Required**: Fundamental changes needed

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
