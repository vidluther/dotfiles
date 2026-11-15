---
description: Draft or publish tickets from the current conversation via @ticketmaster
---

Delegate ticket work from this conversation to the `ticketmaster` subagent.

Additional instructions from user (if any): $ARGUMENTS

Build a complete handoff brief from our conversation because `ticketmaster` starts with zero chat history:
- Goal / scope and target tracker, project, or epic (if known)
- Problem statement and literal error messages, logs, or repro steps
- Verified `path/file:line` references and relevant PR/ticket keys
- Agreed design decisions, vertical slices, or ISA/ISC references (`rubber-duck` / `to-issues` output)
- Approval state: state explicitly whether I already approved exact ticket drafts in chat, or whether `ticketmaster` must return drafts first

If drafts are not yet approved, present `ticketmaster`'s returned drafts to me in chat, wait for my approval, and then resume the same `ticketmaster` `sessionID` to publish them.
