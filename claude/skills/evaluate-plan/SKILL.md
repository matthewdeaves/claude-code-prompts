---
name: evaluate-plan
description: Evaluate a project plan for Claude Code compatibility. Use when reviewing implementation plans, project breakdowns, or task lists to assess how well they will work with Claude Code's iterative workflow.
allowed-tools: Read, Glob, Grep
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

## Common Problems to Flag

- **Monolithic tasks**: Single tasks that span multiple unrelated concerns
- **Implicit dependencies**: Features that assume other work is complete without stating it
- **Deferred foundations**: Core architecture decisions pushed to later phases
- **Missing verification steps**: No tests or checks between implementation stages
- **Overloaded scope**: Too many requirements packed into individual tasks

## Instructions

1. Read the plan provided by the user (file path or pasted content)
2. Evaluate against each of the five criteria above
3. Identify specific problems using the "Common Problems" patterns
4. Provide your assessment in the format below

## Output Format

Provide your assessment as:

### Overall Rating
How well-suited is this plan for Claude Code implementation?
- **Good**: Ready to implement with minor tweaks
- **Needs Adjustment**: Workable but should address specific issues first
- **Major Restructuring Required**: Fundamental changes needed

### Strengths
What aspects of the plan work well?

### Issues Found
Specific problems identified, referencing the criteria above.

### Recommended Changes
Concrete suggestions to improve the plan:
- How to restructure large tasks
- What to prioritise differently
- Missing elements to add
- A suggested revised task order if applicable
