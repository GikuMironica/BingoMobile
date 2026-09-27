---
name: flutter-legacy-modernization
description: Modernize this legacy Flutter/Dart application safely to Flutter 3.24.5 and Dart 3.5, including null safety, dependency upgrades, generated code, and architecture refactoring while preserving UI behavior.
user-invocable: false
---

# Flutter legacy modernization

## Runtime and commands

- The project target is Flutter `3.24.5` with Dart `3.5.4`, pinned by `.fvmrc`.
- Prefer `fvm flutter` and `fvm dart`. On this Windows workstation, FVM is installed under the user's local programs directory and `.fvm/flutter_sdk` is an ignored project junction.
- Never run `flutter build` or `flutter run` unless separately authorized.
- Use `fvm flutter pub get`, `fvm flutter analyze`, `fvm flutter test`, `fvm dart format`, and code generation when the current migration state supports them.

## Null-safety migration

- Dart 3 no longer provides the old interactive `dart migrate` workflow. Use compiler/analyzer-guided migration.
- First inventory language-version constraints, generated files, dependency compatibility, and unresolved source-control markers.
- Update nullable types intentionally. Prefer required constructor parameters, safe defaults only when semantically correct, and explicit nullable state where absence is valid.
- Avoid broad `late`, `!`, dynamic casts, blanket ignores, and behavior-changing defaults. Every escape hatch needs a concrete invariant or TODO.
- Regenerate code rather than hand-editing generated output when a compatible generator exists.
- Preserve API behavior and visual behavior while changing types.

## Dependency constraints

- Choose versions compatible with Flutter 3.24.5 / Dart 3.5, not blindly the newest release available in 2026.
- Upgrade in the playbook's batches and inspect changelogs for breaking APIs.
- The absent vendored `plugins/here_sdk` dependency is a known blocker with its own Step 0.3-H. Never create a fake plugin or hardcode a HERE key.
- If dependency resolution makes the written 0.2/0.3/0.3-H order impossible, prove it with command output, then document and apply the smallest prerequisite reorder rather than masking the issue.
- Keep lockfile changes intentional and review direct/transitive version changes before committing.

## Refactoring rules

- Preserve UI/UX and user flows.
- Keep domain code pure Dart in the target architecture.
- Use constructor injection and existing `get_it`/`injectable` conventions.
- Move network failures toward `Result<T, AppFailure>`; do not introduce new exception swallowing.
- Keep DTOs separate from domain entities and use generated serialization for new target code.
- Do not mix unrelated cleanup into dependency or null-safety batches.

## Platform constraints

- This workstation is Windows. iOS-only validation must be recorded for later macOS execution, not fabricated.
- Static Android/iOS configuration inspection is allowed.
- Credentials and environment values must remain externalized and uncommitted.
