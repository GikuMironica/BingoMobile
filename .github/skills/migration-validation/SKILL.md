---
name: migration-validation
description: Validate Hopaut migration batches with formatting, dependency resolution, static analysis, focused tests, regression checks, and truthful acceptance-gate reporting. Load after migration edits and before marking steps complete.
user-invocable: false
---

# Migration validation

## Validation ladder

Run the strongest applicable checks in this order:

1. Syntax and editor diagnostics for changed files.
2. `git diff --check`.
3. Format checks for changed Dart files; format intentionally and review the diff.
4. Dependency resolution when dependency metadata changed.
5. `fvm flutter analyze` or the narrowest available analyzer invocation.
6. Focused tests covering the changed behavior.
7. Full `fvm flutter test` when the repository state permits it.
8. Platform configuration checks relevant to the batch.

Do not run `flutter build` or `flutter run` without explicit user authorization.

## Failure handling

- Distinguish pre-existing failures from regressions introduced by the current batch.
- Capture exact command, exit code, and actionable error summary in the tracker.
- Fix relevant failures before moving on.
- After three failed evidence-based attempts at the same issue, stop that line of work and record a concrete blocker.
- Never claim a command passed if it did not run to completion.
- Never delete, weaken, or rewrite tests merely to obtain green output.

## Acceptance gates

A step may be `✅` only when:

- Every non-waived acceptance criterion is demonstrated.
- Generated files are current when generators are part of the change.
- Relevant analyzer errors are zero, unless the playbook explicitly defines a narrower intermediate gate.
- Relevant tests pass, or the absence of runnable tests is explicitly documented and accepted.
- The tracker contains the date, result, validation summary, and stable implementation commit hash when available.

## Review before commit

- Inspect `git status` and the complete diff.
- Ensure no secrets, build outputs, SDK caches, or unrelated user files are staged.
- Confirm UI/UX remains unchanged unless explicitly requested.
- Ensure comments explain intent rather than restating code.
- Keep commits coherent and reversible.
