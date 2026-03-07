---
name: exit-plan
description: End-of-session wrap-up ritual. Triggers whenever the user types /exit, "exit session", "wrap up", "end session", or "I'm done for today". Guides the user through a structured session close: reviewing goals, updating .plan.md status markers, deciding whether to archive or delete .plan.md, and capturing any decisions or context that should be written back into the codebase (README, ARCHITECTURE.md, etc.) before the session ends. Always run this skill at session end — do not just say goodbye without prompting the user to do a proper wrap-up.
---

# Exit Plan

A structured end-of-session ritual inspired by the Unix `.plan` / `.project` finger protocol — the idea that your current working intent should always be readable, and cleanly handed off or closed out.

## The Ritual

Work through these steps in order. Be conversational, not robotic — this is a brief check-in, not a form to fill out.

### 1. Goal Review

Ask: **"Did you accomplish what you set out to do today?"**

- If **yes**: affirm it, note what was completed
- If **partial**: ask what's left and whether it should carry forward
- If **no**: ask why — was it scope creep, a blocker, or a pivot? This matters for how to update `.plan.md`

### 2. Update .plan.md

Based on the goal review, update task markers in `.plan.md`:

- `[x]` for anything completed this session
- `[!]` for anything blocked — add an inline note explaining why
- `[ ]` for anything that carries forward unchanged
- Remove any `%%` annotations that were already incorporated

If all tasks are `[x]`, prompt:

> "Everything looks done. Do you want me to delete `.plan.md`, or archive it first?"

Archiving suggestion: `mv .plan.md .plan-$(date +%Y-%m-%d).md` — lets them keep a dated log if they want one. Mention that `.plan.md` should be in `.gitignore` so this doesn't affect the repo.

If tasks remain, remind them:

> "Next session, I'll read `.plan.md` and summarize state before we do anything."

### 3. Knowledge Capture Check

Ask: **"Did we make any decisions today that should live in the codebase rather than just in this chat?"**

Prompt them to think about:

- Architecture or pattern decisions → `ARCHITECTURE.md`
- Setup steps or gotchas → `README.md`
- New conventions → `CLAUDE.md`
- Anything that future-Claude will need to know cold at the start of next session

If yes, write those updates now before closing. Do not leave institutional knowledge stranded in chat history.

### 4. Issue/PR Hygiene

If an issue ID was referenced in `.plan.md`, ask:

> "Should I draft a summary comment for the Jira/GitHub issue before we close?"

Keep it short — just what was done, any decisions made, and what's next if the issue isn't closed.

### 5. Sign Off

Close with a brief summary of the session — one or two sentences. Something like:

> "Good session — you got the Supabase RLS policy working and documented the pattern in ARCHITECTURE.md. The .plan.md is cleaned up and ready for next time."

---

## Notes on the .plan Tradition

The Unix `finger` command (1971) would show a remote user's `.plan` file when you fingered them — it was their current working context, publicly readable. The companion `.project` file held the broader effort. This skill is that pattern applied to AI-assisted development: your `.plan.md` is your `.plan`, and your `README`/`ARCHITECTURE.md` are your `.project`. Keep them honest.
