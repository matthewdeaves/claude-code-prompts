# Implementable Skill - Future Improvements

Improvement suggestions identified during review on 2026-01-15.

## Structural Improvements

### 1. Consider Splitting the Skill

The skill currently serves two distinct purposes:
- **Evaluation mode**: Check if a plan is implementable
- **Creation mode**: Generate QA round documents (lines 487-628)

These are triggered differently and serve different purposes. The title "Is Your Plan Implementable?" suggests evaluation only.

**Recommendation**: Extract QA round creation into its own skill (e.g., `qa-round-creator`). This would:
- Make each skill's purpose clearer
- Reduce cognitive load when just evaluating
- Allow independent evolution of each capability

### 2. Extract Templates to Separate Files

The detailed templates add significant length to the main skill file:
- QA Round template: ~90 lines
- QA Issue template: ~35 lines

**Recommendation**: Create a `templates/` subdirectory:
```
skills/implementable/
  SKILL.md
  templates/
    QA-ROUND-TEMPLATE.md
    QA-ISSUE-TEMPLATE.md
```

Reference these from the main skill file rather than embedding them inline.

### 3. Consolidate State Management

State management guidance is currently spread across:
- Section 8 (evaluation criteria)
- "State Management Instructions for Claude" section
- State transitions in QA templates

**Recommendation**: Merge into one coherent section with clear subsections:
- "What to Evaluate" (criteria for assessment)
- "How to Implement" (operational guidance for Claude)

### 4. Add Section Navigation

At 628 lines, the document is long. Navigation aids would help.

**Recommendation**: Add a table of contents at the top:
```markdown
## Contents
- [Core Principle](#core-principle-land-and-expand)
- [Evaluation Criteria](#what-makes-a-plan-implementable)
- [Common Problems](#common-problems-to-flag)
- [Instructions](#instructions)
- [Output Format](#output-format)
- [QA Workflow](#qa-workflow-assessment-when-applicable)
- [State Management](#state-management-instructions-for-claude)
- [QA Round Creation](#qa-round-detection-and-creation)
```

### 5. Deduplicate Splitting Guidance

The "when to split" patterns for phases (lines 219-265) and QA documents (lines 294-376) follow identical logic with different examples.

**Recommendation**: Create a unified "Document Splitting Principles" section that explains the pattern once, then provide brief examples for each document type:
- Implementation plans: split at 5+ phases
- QA documents: split at 30+ issues or multiple platforms

## Content Improvements

### 6. State Transition Diagram Consolidation

The same state transition diagram appears three times:
- Lines 95-99 (evaluation criteria)
- Lines 346-351 (QA issue template)
- Lines 555-562 (QA round template)

**Recommendation**: Define the diagram once in the State Management section, then reference it elsewhere:
```markdown
See [State Transitions](#state-transitions) for the standard flow.
```

### 7. Test Coverage as Standalone Criterion

Test coverage requirements (lines 40-51) are currently embedded within the "Testability" criterion but are substantial enough to warrant separation.

**Recommendation**: Either:
- Make test coverage criterion #5 and renumber subsequent criteria
- Or create a clear subheading structure within Testability

## Low Priority

### 8. Clarify Example Phase Count

Line 265's example recommendation references 9 phases. While this correctly demonstrates the 5+ splitting rule, consider adding variety:
- One example at the threshold (5-6 phases)
- One example well above (9+ phases)

---

## Implementation Notes

When implementing these changes:
1. Start with the minor consolidations (state diagrams, splitting guidance)
2. Add table of contents
3. Consider skill split only if the file continues to grow
4. Template extraction can wait until templates stabilize

**Estimated complexity**: Medium - mostly reorganization, no new functionality.
