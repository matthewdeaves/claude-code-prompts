---
name: blog-improver
description: Evaluate blog post drafts and suggest improvements. Like implementable but for content - evaluates against quality criteria and provides structured feedback for iteration.
allowed-tools: Read Glob Grep
---

# Blog Improver

Evaluate blog post drafts against quality criteria and provide actionable feedback for iteration.

## Purpose

This skill evaluates blog posts the way the `implementable` skill evaluates implementation plans. It provides:
- Structured assessment against defined criteria
- Specific issues with locations
- Concrete suggestions for improvement
- A rating system for publication readiness

## Invocation

- `/blog-improver` - Evaluate the draft in conversation or ask for file path
- `/blog-improver path/to/post.md` - Evaluate specific file
- `/blog-improver section:opening` - Focus on specific section (for long posts)

---

## Evaluation Criteria

### 1. Thesis Clarity

**Questions:**
- Is the core point obvious within the first few paragraphs?
- Could a reader summarize the post in one sentence?
- Does the post deliver on what the opening promises?

**Red flags:**
- Thesis buried deep in the post
- Multiple competing main points
- Reader would struggle to explain "what this post is about"
- Opening promises something the post doesn't deliver

### 2. Structure

**Questions:**
- Does it have logical flow from section to section?
- Are sections appropriately sized? (not too long, not too sparse)
- Does each section earn its place?
- Are transitions smooth?

**Red flags:**
- Sections that could be deleted without loss
- Jarring jumps between topics
- One section much longer than others without reason
- No clear progression through the content
- Missing sections (e.g., jumps to solution without setup)

### 3. Voice

**Questions:**
- Is it conversational without being sloppy?
- Is it succinct without being terse?
- Does it avoid corporate-speak and filler?
- Does it sound like a person, not a press release?

**Red flags:**
- Marketing language ("leverage", "synergy", "unlock")
- Unnecessary qualifiers ("I think", "in my opinion", "perhaps")
- Filler phrases ("it's worth noting", "needless to say", "at the end of the day")
- Walls of text without paragraph breaks
- Overly formal or stiff tone
- Forced casualness that feels fake
- AI-sounding patterns (see "AI Writing Tells" section below)

### 4. Specificity

**Questions:**
- Does it use real examples, not hypotheticals?
- Are there concrete details, not vague gestures?
- Does it include code/commands where appropriate?
- Can the reader actually follow along?

**Red flags:**
- "For example, you might..." without actual example
- Vague references ("some tools", "many developers")
- Missing code for technical tutorials
- Hypothetical scenarios instead of real ones
- Claims without evidence

### 5. Narrative

**Questions:**
- Is there a through-line connecting sections?
- Does it build toward something?
- Is there any sense of journey or progression?

**Red flags:**
- Just a list of points with no connection
- Could reorder sections without noticing
- No sense of movement from start to end
- Reader gets to the end and thinks "so what?"

### 6. Completeness

**Questions:**
- Are there gaps or unanswered questions raised?
- Does it deliver on the opening's promise?
- Are there loose threads?
- Is anything missing that readers would expect?

**Red flags:**
- Questions raised but never addressed
- "We'll cover this later" but never does
- Missing obvious objections or counterpoints
- Assumed knowledge that should be explained
- Steps missing in tutorials

### 7. Momentum

**Questions:**
- Does the opening hook the reader?
- Does the closing have energy?
- Does it end with forward motion?

**Red flags:**
- Weak opening that buries the lede
- "In this post, I will discuss..." openings
- Summary-style conclusions ("In conclusion, we covered...")
- Platitude endings ("And that's why X matters")
- Endings that just... stop

---

## Instructions

1. **Read the draft** - Load from file or receive in conversation

2. **Assess holistically first** - Read through completely before evaluating
   - What's the thesis?
   - What type of post is this?
   - What's working? What's not?

3. **Evaluate each criterion** - Go through all 7 systematically
   - Note specific issues with locations
   - Note where criteria are met well (strengths)

4. **Determine rating**:
   - **Ready to Publish** - Minor polish only, core is solid
   - **Needs Work** - Good foundation, specific issues to fix
   - **Needs Restructure** - Structural problems require significant rework

5. **Prioritize recommendations** - Not everything is equally important
   - High priority: Things that must change
   - Nice to have: Polish items

6. **Provide example fixes** - For top issues, show concrete improvements
   - Before/after for sentence-level fixes
   - Rewrite suggestions for section-level problems

---

## Output Format

```markdown
## Blog Improver Assessment

### Post Info
- **File:** [path or "from conversation"]
- **Word count:** ~[N]
- **Detected type:** [Methodology | Tutorial | Analysis | Case Study | Other]
- **Current structure:** [List detected sections]

### Rating: [Ready to Publish | Needs Work | Needs Restructure]

[1-2 sentence summary of overall assessment]

---

### Strengths

- [What works well - be specific, cite examples from the text]
- [Credit good choices - structure, voice, examples]
- [Note what should be preserved in revisions]

---

### Issues Found

| # | Criterion | Issue | Location |
|---|-----------|-------|----------|
| 1 | [Criterion] | [Specific problem] | [Section or paragraph] |
| 2 | [Criterion] | [Specific problem] | [Section or paragraph] |

---

### Recommended Changes

**High priority:**
1. [Specific change - be concrete about what to do]
2. [Specific change]

**Nice to have:**
1. [Polish item]
2. [Polish item]

---

### Example Fixes

**Issue #[N]: [Brief description]**

Before:
> [Current text from draft]

After:
> [Suggested revision]

Why: [Brief explanation of the improvement]

---

**Issue #[N]: [Brief description]**

[Rewrite suggestion or structural guidance]
```

---

## Common Patterns to Flag

### Opening Problems

**The Announcement Opening:**
> "In this post, I'm going to talk about X. We'll cover Y and Z, and by the end you'll understand..."

Fix: Lead with something interesting. Hook first, roadmap later (if at all).

**The Buried Lede:**
The interesting part is in paragraph 4. Everything before is throat-clearing.

Fix: Cut the first 3 paragraphs, start where it gets interesting.

**The Definition Opening:**
> "What is X? X is defined as..."

Fix: Assume reader knows the basics or show why they should care first.

### Closing Problems

**The Summary Conclusion:**
> "In conclusion, we've seen that X, Y, and Z. I hope this has been helpful."

Fix: End with forward motion - what's next, what reader should do, new question raised.

**The Platitude Ending:**
> "And that's why [obvious statement that adds nothing]."

Fix: Either end on a concrete note or leave them thinking.

**The Fade Out:**
Post just stops without any sense of completion.

Fix: Tie back to opening, look forward, or give clear next steps.

### Structure Problems

**The List Post in Disguise:**
Numbered sections with no connection between them.

Fix: Add transitions, find the narrative thread, or own it as a list post.

**The Monolith:**
One giant section with no breaks.

Fix: Find natural break points, add subheadings, vary paragraph length.

### Voice Problems

**The Corporate Filter:**
> "Leveraging AI tools enables developers to unlock productivity gains and drive innovation forward."

Fix: Say it like a person would: "AI tools save time. Here's how I use them."

**The Hedge Everything:**
> "I think that perhaps this might be a good approach, in my opinion."

Fix: Make claims directly. "This approach works because..."

### AI Writing Tells

Patterns that make content feel AI-generated:

**The Triple Opening:**
> "In today's fast-paced world..." / "Have you ever wondered..." / "Let's dive in..."

Fix: Start with something specific to your experience or topic.

**Fake Enthusiasm:**
> "This exciting new approach is a powerful game-changer..."

Fix: Drop the adjectives. Let the content speak for itself.

**Empty Transitions:**
> "Now let's look at..." / "Moving on to..." / "Another important point is..."

Fix: Transitions should connect ideas, not announce topic changes.

**The False Question:**
> "So what does this mean for your workflow?"

Fix: If you're about to answer it immediately, just say the thing.

**List Exhaustion:**
Every section becomes bullets. Prose disappears entirely.

Fix: Vary structure. Use paragraphs for flowing ideas, lists for reference items.

**Cliché Closings:**
> "At the end of the day..." / "The bottom line is..." / "Only time will tell..."

Fix: End on something concrete - a specific action, insight, or question.

---

## Iteration Workflow

The goal is iterative improvement until the post reaches "Ready to Publish."

```
1. Run /blog-improver on draft
2. Review the assessment (don't just accept blindly)
3. Address high-priority issues first
4. Run /blog-improver again
5. Repeat until "Ready to Publish"
```

### Session Management for Long Posts

For posts over ~2000 words:
- Can evaluate specific sections: `/blog-improver section:opening`
- After major restructure, `/clear` and re-evaluate fresh
- Focus on one criterion at a time for deep issues

### When to Stop Iterating

Stop when:
- Rating is "Ready to Publish"
- Remaining issues are subjective polish
- Further changes would be rearranging deck chairs
- You're making changes to changes

### Judgment Calls

Not everything is fixable or even needs fixing:
- Some posts work despite breaking "rules"
- Voice is personal - guidelines, not laws
- Good enough is often good enough
- Ship it and learn from reader feedback

---

## Integration with blog-writer

This skill pairs with `blog-writer`:

```
/blog-writer skeleton → create outline
/blog-writer write → generate draft
/blog-improver → evaluate draft
[fix issues]
/blog-improver → re-evaluate
[repeat until ready]
```

Or use standalone on any existing draft:
```
/blog-improver path/to/existing-post.md
```
