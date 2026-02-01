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
