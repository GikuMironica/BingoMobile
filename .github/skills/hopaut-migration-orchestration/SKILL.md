---
name: hopaut-migration-orchestration
description: Orchestrate the Hopaut mobile migration across ordered playbook steps, tracker updates, validation gates, and local Git commits. Load whenever continuing or automating work from mobile-migration-status.md.
user-invocable: false
---

# Hopaut migration orchestration

## Sources of truth

Read, in order:

1. `mobile-migration-status.md` for current state.
2. `mobile-playbook.md` for goals, actions, ordering, and acceptance criteria.
3. `.github/github-copilot-instructions.md` for repository rules.

Never infer progress from memory when the tracker is available.

## Step selection

- Select the earliest `🟡`, then the earliest `⬜`, whose prerequisites are satisfied.
- The autonomous agent invocation authorizes sequential batching, but not reordering dependencies without evidence.
- If the written order is technically impossible, document the dependency conflict and make the smallest justified ordering correction in both the playbook and tracker.
- Do not silently skip blocked work. Use `❌ blocked` with evidence or `⏭️` only for an explicit user-approved skip.

## Per-step procedure

1. Confirm branch and working-tree state.
2. Inspect all affected files and usages before editing.
3. Set the tracker row to `🟡`, fill the date and remaining work, and add an activity row.
4. Implement in coherent, reviewable batches.
5. Validate against the step's acceptance criteria and the migration-validation skill.
6. Update the tracker to `✅`, `🟡`, or `❌ blocked` truthfully.
7. Commit implementation plus the current tracker state.
8. Record the stable implementation hash in the tracker and make a small tracking commit when needed.
9. Confirm the working tree is clean before selecting the next step.

## Git discipline

- Local commits are authorized for this migration agent.
- Never amend, reset, rebase, force-push, or discard unrelated work.
- Never push or merge to `master` without separate explicit approval.
- Prefer one implementation commit per coherent batch and a small follow-up tracker commit when a stable hash must be recorded.
- Use concise conventional-style messages such as `chore:`, `refactor:`, `fix:`, `test:`, or `docs:`.

## Progress durability

Before any stop:

- Leave no ambiguous half-edit.
- Update the tracker with what succeeded, what failed, and the exact next action.
- Commit coherent work; do not commit known broken generated artifacts unless the tracker clearly marks an intentional intermediate state.
- Include command output summaries and relevant commit hashes in the final report.
