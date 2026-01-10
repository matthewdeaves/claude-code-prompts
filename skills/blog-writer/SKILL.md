---
name: blog-writer
description: Transform brain dumps into structured blog posts. Use 'discover' to scan docs and find themes, 'skeleton' to create an outline, or 'write' to flesh out a draft. Supports methodology, tutorial, analysis, and case study post types.
allowed-tools: Read Glob Grep
---

# Blog Writer

Transform scattered notes and brain dumps into polished blog posts.

## Modes

This skill has three modes:

- **discover** - Scan docs and suggest potential blog post themes
- **skeleton** - Analyze input and create a structured outline
- **write** - Expand a skeleton into a full draft

If no mode is specified, ask which mode to use.

---

## Mode: Discover

Analyze a collection of notes/docs and surface potential blog post themes.

### When to Use

- You have a directory of notes but don't know what to write about
- You want to see what themes emerge from your collected thoughts
- You're looking for the post that's "ready to write"

### Process

1. **Scan the content** - Given a directory or file list:
   ```
   1. Glob for all relevant files (*.md, *.txt, notes/*)
   2. Read each file, noting key themes and topics
   3. Look for: recurring ideas, strong opinions, detailed examples, unanswered questions
   ```

2. **Identify clusters** - Group related content:
   - What topics appear across multiple files?
   - Where is there the most depth/detail?
   - What has concrete examples vs just ideas?
   - What questions keep coming up?

3. **Assess readiness** - For each potential theme:
   - **Ready to write**: Has thesis, examples, structure emerging
   - **Needs development**: Good idea but missing pieces
   - **Seed only**: Interesting but needs more thinking

4. **Present options** - Show the user what's there

### Discover Output Format

```markdown
## Blog Post Discovery

**Scanned:** [N] files in [path]
**Date:** [current date]

---

### Ready to Write

These themes have enough material for a post:

**1. [Theme Title]**
- **Thesis emerging:** [One sentence]
- **Type:** [Methodology | Tutorial | Analysis | Case Study]
- **Sources:** [file1.md], [file2.md]
- **Strength:** [What's already there - examples, structure, argument]
- **Gap:** [What's missing or needs work]

**2. [Theme Title]**
...

---

### Needs Development

Good ideas that need more material:

**1. [Theme Title]**
- **Core idea:** [Brief description]
- **Sources:** [files]
- **Missing:** [What would make this ready]

---

### Seeds

Interesting fragments worth tracking:

- [Idea] - in [file] - [why it's interesting]
- [Idea] - in [file]

---

### Suggested Next Step

[Recommend which theme to pursue and why, or what to develop further]
```

### After Discovery

Once the user picks a theme:
- Run `skeleton` mode focused on that theme
- The skeleton will pull from the identified source files

---

## Mode: Skeleton

Create a structured outline from unstructured input.

### Prompted Skeleton

You can provide direction alongside your sources in natural language:

```
/blog-writer skeleton I want to write about the hidden costs of microservices.
Start with the promise they make, then show what actually happens at scale.
Pull from architecture-notes.md for war stories.
```

Direction can include:
- **Angle/thesis** - the point you want to make
- **Structural requests** - "start with X", "end with Y", "include a section on Z"
- **Topic focus** - what to look for in source files

When direction is provided:
- Use it as the thesis foundation
- Search sources for supporting material
- Flag if sources contradict or complicate the direction
- Structure the skeleton around the user's requests

When no direction is provided:
- Infer thesis from source material (original behavior)
- Ask user if thesis is unclear

### Process

1. **Gather source material** - Collect content from what the user provides:

   **Single input:**
   - Brain dump in conversation
   - Single notes file
   - Pasted content

   **Multiple files:**
   - Directory path → use Glob to find relevant files (*.md, *.txt, notes/*)
   - Multiple file paths → read each one
   - Topic keyword → use Grep to find related content across files

   **When given a directory or topic:**
   ```
   1. Glob for relevant files (*.md, *notes*, *draft*, etc.)
   2. Read promising files to assess relevance
   3. Grep for topic keywords to find scattered references
   4. Synthesize content from multiple sources
   ```

   **What to look for in source files:**
   - Main arguments or points
   - Examples and evidence
   - Code snippets or commands
   - Quotes or references
   - Questions raised
   - Conclusions reached
   - Contradictions to resolve

   Don't require organization. The mess is the input.

2. **Synthesize and identify thesis** - What's the core point?
   - **If user provided direction:** Use their angle as the thesis foundation. Find supporting material in sources.
   - **If inferring from sources:** What should the reader take away? What's the one sentence that captures this post?
   - If sources contradict user direction, flag it in the gaps section.
   - If you can't identify a clear thesis, ask the user.

3. **Detect post type** - Which structure fits best?
   - **Methodology/Process** - "Here's how I do X"
   - **Technical Tutorial** - "Here's how to build X"
   - **Analysis/Opinion** - "Here's why X is better than Y"
   - **Case Study** - "Here's what happened when we built X"

4. **Choose structure** - Select the appropriate template (see Structures below)

5. **Create outline** - Build section-by-section skeleton:
   - Each section gets a heading and bullet points
   - Include key points that must be covered
   - Note where examples or code snippets are needed
   - Indicate transitions between sections

6. **Flag gaps** - Identify what's missing:
   - Missing examples or evidence
   - Unclear points that need expansion
   - Research needed
   - Questions for the user

7. **Output the skeleton** - Present the outline for review or expansion

### Skeleton Output Format

```markdown
## Skeleton: [Working Title]

**Thesis:** [One sentence core argument]
**Type:** [Methodology | Tutorial | Analysis | Case Study]
**Structure:** [Structure name from templates]
**Estimated length:** [Short ~800w | Medium ~1500w | Long ~2500w]

### Sources Used
- [path/to/file1.md] - [brief note on what was pulled from it]
- [path/to/file2.md] - [brief note]
- [Conversation input] - [if applicable]

---

### Outline

**1. Opening**
Hook: [Approach - question, bold claim, scenario, etc.]
- [Key point to establish]
- [Context to set up]

**2. [Section Name]**
- [Key point]
- [Key point]
- [Example needed: describe what's needed]

**3. [Section Name]**
- [Key point]
- [Code snippet: describe what to show]
- [Key point]

**4. [Section Name]**
- [Key point]
- [Key point]

**5. Closing**
- [Main takeaway]
- [Forward momentum / call to action / next steps]

---

### Gaps to Address
- [ ] [Missing piece - be specific]
- [ ] [Needs example for X]
- [ ] [Unclear: should this cover Y?]

### Notes
[Any observations about the content, potential issues, or suggestions]
```

---

## Mode: Write

Expand a skeleton into a complete draft.

### Process

1. **Load skeleton** - Get the outline from:
   - A file path provided by the user
   - The conversation (if skeleton mode was just run)
   - Ask the user to provide one if not available

2. **Expand sections** - For each section:
   - Turn bullet points into paragraphs
   - Maintain the planned structure
   - Fill in flagged examples and code snippets
   - Write natural transitions between sections

3. **Apply voice** - Write with these characteristics:
   - Conversational, like explaining to a peer
   - Direct and honest
   - Specific with real details
   - Varied sentence and paragraph length

4. **Add specifics** - Make it concrete:
   - Real examples, not hypotheticals
   - Actual code, commands, or configurations
   - Specific numbers, names, tools
   - Screenshots or diagrams where helpful (note where they should go)

5. **Craft the opening** - Hook the reader:
   - Lead with something interesting
   - Set up tension or a question
   - Get to the point quickly

6. **Craft the closing** - End with momentum:
   - Tie back to the opening if possible
   - Forward-looking, not backward-summarizing
   - Leave reader with something actionable or thought-provoking
   - Avoid platitudes and forced conclusions

7. **Self-review** - Check the draft against quality criteria before presenting

### Voice Guidelines

**Do:**
- Write like explaining to a peer over coffee
- Be direct and honest
- Use specific examples with real details
- Vary sentence and paragraph length
- Include inline code naturally (for technical content)
- Show the journey, not just the destination
- End with momentum, not platitudes

**Don't:**
- Use corporate or marketing speak
- Pretend to have all answers
- Over-explain basics your audience knows
- Force conclusions ("and that's why...", "in conclusion...")
- Add unnecessary qualifiers ("I think", "in my opinion")
- Use filler phrases ("it's worth noting that", "it goes without saying")
- Write walls of text without breaks

### Common AI Writing Patterns to Avoid

These patterns make writing feel generic and AI-generated:

- **The triple opening** - "In today's fast-paced world..." / "Have you ever wondered..." / "Let's dive in..."
- **Fake enthusiasm** - "exciting", "powerful", "game-changing", "revolutionary"
- **Empty transitions** - "Now let's look at...", "Moving on to...", "Another important point is..."
- **The summary sandwich** - Telling them what you'll tell them, telling them, telling them what you told them
- **Hedging everything** - "can be", "might help", "could potentially" when you mean "does", "helps", "will"
- **List exhaustion** - Every section becomes a bulleted list instead of prose
- **The false question** - "So what does this mean?" when you're about to tell them anyway
- **Cliché closings** - "At the end of the day...", "The bottom line is...", "Only time will tell..."

Write like you're explaining something you actually did to someone who actually cares.

### Technical Content Guidelines

When writing technical posts:
- Assume reader competence, explain when necessary
- Show actual commands and real output
- Be honest about limitations and trade-offs
- Use casual tool references (no need to explain what git is)
- Format code blocks with appropriate language tags
- Include comments in code only when needed for clarity

### Write Output Format

Present the complete draft, then add:

```markdown
---

## Draft Review Checklist

- [ ] Opening hooks the reader (no "In today's..." or "Have you ever...")
- [ ] Thesis is clear within first few paragraphs
- [ ] Each section earns its place
- [ ] Specific examples throughout (real, not hypothetical)
- [ ] Code/commands are accurate and tested
- [ ] Transitions flow naturally (no "Now let's look at...")
- [ ] Closing has momentum (no "At the end of the day...")
- [ ] No corporate-speak, filler, or fake enthusiasm
- [ ] Reads like a human wrote it, not an AI
- [ ] Appropriate length for content

## Notes for Author
[Any observations, suggestions, or flags for review]
```

---

## Structures by Post Type

### Methodology/Process Posts

For posts explaining how you approach something.

```
Opening: The problem this solves
  - Why existing approaches fall short
  - What prompted developing this method

Phase/Step 1: [First part of the process]
  - What you do
  - Why it matters
  - Example or demonstration

Phase/Step 2: [Second part]
  - What you do
  - How it builds on previous
  - Example

[Additional phases as needed]

Results: What this approach achieves
  - Concrete outcomes
  - Comparison to before

Closing: When to use this
  - Ideal scenarios
  - When NOT to use it
  - Where to go from here
```

### Technical Tutorial Posts

For posts teaching how to build or do something.

```
Opening: What we're building and why
  - The end result
  - Why someone would want this
  - Brief preview of approach

Prerequisites: What reader needs
  - Tools and versions
  - Prior knowledge assumed
  - Starting point

Step 1: [First action]
  - What to do (with code)
  - What it accomplishes
  - Expected result

Step 2: [Second action]
  - What to do (with code)
  - How it connects to previous
  - Expected result

[Additional steps]

Result: Working outcome
  - Full working state
  - How to verify it works

Variations: Alternative approaches
  - Different options
  - Trade-offs
  - Extensions
```

### Analysis/Opinion Posts

For posts arguing a position or comparing options.

```
Opening: The question or comparison
  - What's being evaluated
  - Why it matters now
  - Stakes involved

Context: Why this matters
  - Current landscape
  - What prompted this analysis
  - Who cares about this

Argument 1: [First point]
  - The claim
  - Evidence/example
  - Why it matters

Argument 2: [Second point]
  - The claim
  - Evidence/example
  - Connection to previous

[Additional arguments]

Counterpoint: The other side
  - Acknowledge valid opposing points
  - Why they don't change the conclusion
  - Where you might be wrong

Position: Your conclusion
  - Clear statement of position
  - Implications
  - What reader should do with this
```

### Case Study Posts

For posts about a specific project or experience.

```
Opening: The challenge
  - What needed to be done
  - Constraints and context
  - Stakes

Starting Point: Initial state
  - Where things stood
  - Resources available
  - Key decisions to make

Approach: What you did (and why)
  - Strategy chosen
  - Alternatives considered
  - Key trade-offs made

Execution: Key moments/decisions
  - What actually happened
  - Surprises and pivots
  - Specific examples

Results: What happened
  - Concrete outcomes
  - Metrics if applicable
  - Comparison to goals

Lessons: What you'd do differently
  - What worked well
  - What you'd change
  - Advice for others
```

---

## Workflow Examples

### Example 1: Discover themes from notes directory

User says:
```
/blog-writer discover ~/notes/engineering/
```

Process:
1. Glob all .md files in directory
2. Read each file, extract themes and topics
3. Identify clusters of related content
4. Assess which themes have enough material

Output:
```markdown
## Blog Post Discovery

**Scanned:** 12 files in ~/notes/engineering/

### Ready to Write

**1. Database Migration Strategies**
- **Thesis emerging:** Zero-downtime migrations require planning that most teams skip
- **Type:** Methodology
- **Sources:** postgres-notes.md, incident-2024-03.md
- **Strength:** Full migration checklist, real incident with timeline, recovery steps
- **Gap:** Needs before/after metrics, team coordination section

**2. When to Break the Monolith**
- **Thesis emerging:** Most teams extract services too early; here's how to know when it's time
- **Type:** Analysis
- **Sources:** architecture-decisions.md, scaling-notes.md
- **Strength:** Clear decision framework, war stories
- **Gap:** Needs counterexamples, cost analysis

### Suggested Next Step
Theme #1 has the most material and clearest structure. Run `/blog-writer skeleton` focused on the migration methodology.
```

User then says: "let's do #1"
→ Proceed to skeleton mode for that theme

### Example 2: Skeleton from brain dump

User provides:
```
thoughts on using cursor vs claude code
- cursor is in IDE, feels familiar
- but claude code is in terminal, my natural environment
- tried cursor first, felt weird leaving vim
- claude code met me where I was
- not about which is better, about workflow fit
- some devs love IDE integration
- I need terminal access
```

Process:
1. Identify thesis: "Choose AI tools that fit your workflow, not the other way around"
2. Detect type: Analysis/Opinion
3. Build skeleton with opening hook about tool debates, journey through trying both, conclusion about workflow fit
4. Flag gaps: needs specific examples of what felt wrong/right in each tool

### Example 3: Skeleton from directory of notes

User says:
```
/blog-writer skeleton - I want to write about zero-downtime database
migrations. My notes are in ~/notes/engineering/
```

Process:
1. Glob `~/notes/engineering/*.md` to find note files
2. Read `postgres-notes.md` - find migration strategies and gotchas
3. Read `incident-2024-03.md` - find real-world failure case with timeline
4. Grep for "migration" and "downtime" to find scattered references
5. Synthesize: thesis is about planning that prevents migration disasters
6. Detect type: Methodology/Process
7. Build skeleton pulling from multiple sources, noting which file each point came from
8. Flag gaps: needs concrete metrics, team coordination examples

Output includes Sources Used section:
```markdown
### Sources Used
- postgres-notes.md - Migration checklist, locking gotchas, rollback strategies
- incident-2024-03.md - Production incident timeline, recovery steps
- scaling-notes.md - Performance impact observations
```

### Example 4: Write from skeleton

User provides skeleton or references one in conversation.

Process:
1. Expand each section following the outline
2. Write opening that hooks with the tool debate tension
3. Show specific moments (leaving vim, terminal commands)
4. Close with forward momentum about evaluating future tools
5. Run through checklist before presenting

### Example 5: Skeleton with detailed direction

User says:
```
/blog-writer skeleton I want to write about the hidden costs of microservices.
Start with the promise they make, then show what actually happens at scale.
Pull from architecture-notes.md for war stories.
```

Process:
1. Parse user direction: angle is "microservices have hidden costs", structural request is "start with promise, then reality"
2. Read `architecture-notes.md` looking for: scaling issues, operational overhead, specific incidents
3. Thesis foundation from user: "Microservices promise flexibility but extract hidden costs at scale"
4. Detect type: Analysis/Opinion
5. Build skeleton:
   - Opening: the microservices promise (flexibility, independence, scaling)
   - Section 2: what the brochure doesn't mention
   - Section 3: war stories from the trenches (pull specifics from notes)
   - Section 4: when it's worth it anyway
   - Closing: questions to ask before adopting
6. Flag gaps: need specific metrics, team size context, comparison points

The skeleton reflects the user's angle and structure, with sources filling in details.

---

## Integration with blog-improver

After generating a draft with `write` mode, use the `blog-improver` skill to:
1. Get structured evaluation against quality criteria
2. Identify specific issues to address
3. Iterate until "Ready to Publish"

Suggested workflow:
```
/blog-writer skeleton → review/adjust → /blog-writer write → /blog-improver → fix issues → /blog-improver → repeat until ready
```
