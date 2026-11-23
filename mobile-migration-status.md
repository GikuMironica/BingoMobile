# Hopaut Mobile – Migration Status

> Persistent progress tracker. **MUST be updated after every prompt that changes code, configuration, or migration documentation.**
>
> Companion to `mobile-playbook.md` (as-is analysis + target architecture + execution plan in one document).
>
> All work targets the **`dev`** branch (Flutter 2 line). `master` stayed frozen at `v1.2.17` until 2026-11-23, when the user had `dev` merged into it mid-migration (`--no-ff` merges; the requested push to `origin` is pending, see `HANDOVER.md`); it changes again only with explicit approval (Step 6.7 cuts `v2.0.0`).

**Legend**
- ⬜ not started
- 🟡 in progress
- ✅ done
- ❌ blocked (add reason)
- ⏭️ skipped (add reason)

**Current focus:** Phase 0 is externally blocked at Step 0.3-H. Steps 0.2 and 0.3 cannot continue until an authorized HERE Explore Flutter plugin compatible with Flutter 3.24.5 is placed at `plugins/here_sdk`. Frontend tasks to stay in sync with the backend: `HANDOVER.md`.

---

## Phase 0 — Runtime upgrade & foundation

| #      | Step                                                          | Status | Date | Notes / commit |
|--------|---------------------------------------------------------------|--------|------|----------------|
| 0.0    | **Choose Flutter stable target** (Flutter 3.24.5; add `.fvmrc`) | ✅     | 2026-09-27 | Pinned `.fvmrc`; installed FVM 4.3.1; verified Flutter 3.24.5 / Dart 3.5.4 (Windows junction workaround for symlink privilege). Commit `e2a7027`. |
| 0.1    | Capture baseline (tag, deps tree, screenshots of top screens) | ✅     | 2026-09-27 | Tagged `75553a4` as `pre-flutter-3.24-baseline`; captured runtime, lockfile inventory, and dependency-resolution failure in `0f0b9fa`. Visual capture waived by user because UI/UX changes are out of scope (`0de8de7`). |
| 0.2    | Widen Dart SDK (`>=3.5.0 <4.0.0`) + adopt null-safety        | 🟡     | 2026-09-27 | in progress – SDK constraint widened in `e4dfab7`; analyzer-guided migration is blocked until the official HERE plugin permits dependency resolution |
| 0.3    | Upgrade Flutter SDK + plugin majors — Batches A–K (excluding HERE SDK) | ⬜ |      | dependency batches are blocked by 0.3-H because each batch requires clean dependency resolution |
| 0.3-H  | **HERE SDK: provision compatible official Flutter plugin**; fix 6 affected files; wrap in `core/maps/here_sdk_adapter.dart` | ❌ blocked | 2026-09-27 | HERE publishes no Flutter package on pub.dev; official licensed archive and credentials require owner access. Place a compatible Explore plugin at ignored path `plugins/here_sdk`, then verify D7 and resume. Evidence/plan: `e4dfab7`. |
| 0.4    | Environment-driven config (`--dart-define-from-file` for API/OneSignal/HERE/FB/ENV) | ⬜ |      |                |
| 0.5    | CI scaffolding (`.github/workflows/mobile-ci.yml`)            | ⬜     |      |                |
| 0.6    | Lint baseline (`analysis_options.yaml`, `dart_code_metrics`, `import_lint`) | ⬜ |      |                |
| 0.7    | Phase 0 exit gate (all above ✅, analyze 0 errors, HERE map functional) | ⬜ |      |                |

## Phase 1 — Core foundations

| #   | Step                                                                 | Status | Date | Notes / commit |
|-----|----------------------------------------------------------------------|--------|------|----------------|
| 1.1 | Lock decision D1 (state management)                                  | ⬜     |      |                |
| 1.2 | Create `core/` skeleton + move `LoggingService` → `core/observability` | ⬜     |      |                |
| 1.3 | `Result<T, AppFailure>` + `AppFailure` sealed family + i18n mapping  | ⬜     |      |                |
| 1.4 | `DioClient` + auth/refresh/error interceptor stack (queued 401 + replay) | ⬜     |      |                |
| 1.5 | `AuthSession` + `AuthService` + secure storage rewiring              | ⬜     |      |                |
| 1.6 | Migrate routing from `fluro` to `go_router` (with auth redirect)     | ⬜     |      |                |
| 1.7 | Add `freezed` + `json_serializable` and prove on one DTO             | ⬜     |      |                |
| 1.8 | Move bootstrap out of widget tree (`app/bootstrap.dart`)             | ⬜     |      |                |
| 1.9 | Phase 1 exit gate                                                    | ⬜     |      |                |

## Phase 2 — Authentication feature (template)

| #   | Step                                                  | Status | Date | Notes / commit |
|-----|-------------------------------------------------------|--------|------|----------------|
| 2.1 | Scaffold `features/authentication/`                   | ⬜     |      |                |
| 2.2 | Domain (entities + use cases)                         | ⬜     |      |                |
| 2.3 | Data (DTOs + mappers + remote source + repo impl)     | ⬜     |      |                |
| 2.4 | Presentation (Cubits + screens + listeners)           | ⬜     |      |                |
| 2.5 | DI wiring + replace legacy `AuthenticationService` callsites | ⬜ |      |                |
| 2.6 | Tests (use cases, mappers, cubits, one widget, one integration) | ⬜ |      |                |
| 2.7 | Phase 2 exit gate                                     | ⬜     |      |                |

## Phase 3 — Account, Settings, Notifications

| #   | Step                                                  | Status | Date | Notes / commit |
|-----|-------------------------------------------------------|--------|------|----------------|
| 3.1 | Scaffold `features/account/` + migrate Account/Profile/EditProfile + OTP | ⬜ |      |                |
| 3.2 | Scaffold `features/settings/` + migrate Settings, push toggles, language | ⬜ |      |                |
| 3.3 | Move OneSignal → `core/notifications/push_service.dart` (unified init) | ⬜ |      |                |
| 3.4 | Replace `geocoder` with `geocoding`                   | ⬜     |      |                |
| 3.5 | Replace `flutter_webview_plugin` with `webview_flutter` | ⬜   |      |                |
| 3.6 | Phase 3 exit gate                                     | ⬜     |      |                |

## Phase 4 — Events, Feed, Attendance, Ratings, Announcements

| #    | Step                                                                | Status | Date | Notes / commit |
|------|---------------------------------------------------------------------|--------|------|----------------|
| 4.1  | Scaffold `features/events/`; migrate event detail + create + edit sub-screens | ⬜ |      |                |
| 4.2  | Replace hand-written Post/Event/MiniPost/Picture/Location with `freezed` DTOs + entities | ⬜ |      |                |
| 4.3  | Async picture pipeline support (`Pending → Ready` lifecycle) — matches backend Phase 3 | ⬜ |      |                |
| 4.4  | Move multipart upload into `EventRemoteDataSource` (no shared header mutation) | ⬜ |      |                |
| 4.5  | Scaffold `features/feed/`; migrate near-me feed + map search; cursor pagination | ⬜ |      |                |
| 4.6  | Scaffold `features/attendance/`; migrate request/accept/reject/cancel | ⬜  |      |                |
| 4.7  | Scaffold `features/ratings/`; migrate leave-rating + read           | ⬜     |      |                |
| 4.8  | Scaffold `features/announcements/`; migrate inbox/outbox + per-post  | ⬜     |      |                |
| 4.9  | Adopt `DateTimeOffset` parsing (after backend rolls it out); remove `date_time_from_seconds.dart` | ⬜ |      |                |
| 4.10 | Phase 4 exit gate                                                   | ⬜     |      |                |

## Phase 5 — Moderation, Bug Reports, Home shell

| #   | Step                                                              | Status | Date | Notes / commit |
|-----|-------------------------------------------------------------------|--------|------|----------------|
| 5.1 | Scaffold `features/moderation/`; migrate report-post + report-user | ⬜    |      |                |
| 5.2 | Scaffold `features/bug_reports/`; migrate bug submission + screenshot upload | ⬜ |      |                |
| 5.3 | Scaffold `features/home/`; migrate `HomePage` + bottom nav into `StatefulShellRoute` | ⬜ |      |                |
| 5.4 | Phase 5 exit gate                                                 | ⬜     |      |                |

## Phase 6 — Cleanup & hardening

| #   | Step                                                              | Status | Date | Notes / commit |
|-----|-------------------------------------------------------------------|--------|------|----------------|
| 6.1 | Delete legacy folders (`lib/controllers/`, `lib/services/`, `lib/data/`) | ⬜ |      |                |
| 6.2 | Tighten lint rules (no `Provider.of` outside `core/`, no `getIt<>()` in `build()`) | ⬜ |      |                |
| 6.3 | Add golden tests for top 6 screens                                | ⬜     |      |                |
| 6.4 | Add integration tests (login, create event w/ images, attend, rate) | ⬜   |      |                |
| 6.5 | Performance pass (cold start, list scroll, image cache)           | ⬜     |      |                |
| 6.6 | Definition-of-Done check vs `mobile-playbook.md §2.5`              | ⬜     |      |                |
| 6.7 | Cut release tag `v2.0.0` from `dev`; merge to `master`            | ⬜     |      |                |

---

## Decisions

| ID | Decision | Default | Locked-in? | Date |
|----|----------|---------|-----------|------|
| D1 | State management | BLoC v8 (Cubit-first) | ⬜ |   |
| D2 | DTO codegen | `freezed` + `json_serializable` | ⬜ |   |
| D3 | Routing | `go_router` | ⬜ |   |
| D4 | HTTP | `dio` 5.x | ⬜ |   |
| D5 | Result type | hand-rolled sealed class | ⬜ |   |
| D6 | **Flutter version target** | **Flutter 3.24.5 stable / Dart 3.5** | ✅ | 2026-09-27 |
| D7 | **HERE SDK version** | Official downloaded Explore Flutter plugin at `plugins/here_sdk`; `4.22.x` is provisional pending artifact compatibility verification | ⬜ |   |

---

## Activity log (newest first)

| Date | Step | Action | Commit |
|------|------|--------|--------|
| 2026-11-23 | – | Rewrote `HANDOVER.md` as the list of frontend tasks that keep the app in sync with the backend: 10 cross-cutting tasks (S-01 to S-10) and 41 API calls across 8 areas, each mapped to its backend Phase 10 step and mobile plan step, plus the sync procedure, prerequisites and repository state. It replaces the copy of the backend handover. | – |
| 2026-11-23 | – | The push of `dev`, `master` and the tag failed with HTTP 403 (this machine's GitHub credential `mironicaG` has no write access; its SSH key is a BingoAPI deploy key). `HANDOVER.md` and the header above now say the push is pending and give the unblock action. | – |
| 2026-11-23 | – | `HANDOVER.md` corrected and synced again: the backend's GitHub `master` already holds `migrate/net10` since PR #71 (2026-11-18). The user confirmed that no other branch holds migration work and asked to merge `dev` into `master` again and to push `dev`, `master` and the tag `pre-flutter-3.24-baseline` to `origin`. | – |
| 2026-11-23 | – | Added `HANDOVER.md` synced with the backend handover (mobile blocked at 0.3-H; backend at Step 8.6 with its build broken; no pending contract handoffs). The user approved merging `dev` into `master` in its current, mid-migration state: merged locally with one `--no-ff` merge commit (not pushed); work continues on `dev`. | – |
| 2026-09-27 | 0.2, 0.3-H | Reproduced pub failure, confirmed `here_sdk` is absent from pub.dev and officially download-only, found no local artifact, restored the path dependency, and recorded the external provisioning blocker. | `e4dfab7` |
| 2026-09-27 | 0.2, 0.3-H | Proved the written order cannot resolve on Dart 3 because `plugins/here_sdk` is absent; documented the minimal execution interleave and switched HERE to the planned pub.dev constraint. | `e4dfab7` |
| 2026-09-27 | 0.2 | Widened the Dart SDK constraint to `>=3.5.0 <4.0.0`; dependency resolution evidence and analyzer-guided null-safety migration are in progress. | `e4dfab7` |
| 2026-09-27 | 0.2 | Added the repository-scoped `HopautMigration` continuous agent plus orchestration, Flutter modernization, and validation skills; built-in tools are sufficient, so no MCP server was added. | `e652a8b` |
| 2026-09-27 | 0.1 | User scoped migration work to architecture, structure, performance, code smells, and bugs with no UI/UX changes; visual baseline waived and Step 0.1 closed. | `0de8de7` |
| 2026-09-27 | 0.1 | Created the pre-Flutter-3.24 tag and dependency baseline; recorded the visual-baseline blocker after exhausting workspace, history, device, emulator, binary, release, store, and archive sources. | `0f0b9fa` |
| 2026-09-27 | 0.0 | Completed runtime pinning: corrected nonexistent `3.24.6` to Flutter `3.24.5`, installed FVM 4.3.1, and verified Flutter 3.24.5 / Dart 3.5.4. | `e2a7027` |
| 2026-09-27 | – | Consolidated the as-is analysis and execution plan into `mobile-playbook.md`, removed the legacy documents, and updated Copilot workflow references. | `e2a7027` |
| 2025-01-09 | – | **Tightened migration-workflow rules** in `C:\Users\ghmi\personal\BingoMobile\.github\github-copilot-instructions.md`: added exact file-path table for both status files (`C:\Users\ghmi\personal\BingoMobile\mobile-migration-status.md` and `C:\Users\ghmi\personal\BingoAPI\hopaut-migration-status.md`), added exhaustive trigger table (any code/config/doc/handoff change), added step-by-step "How to update" instructions (flip status → fill date → fill notes → prepend activity-log row). Mirrored tightening in backend instructions. | – |
| 2025-01-09 | – | Added *Backend ↔ Mobile contract sync* section to `.github/github-copilot-instructions.md`. Backend (`BingoAPI`) now produces handoff prompt files under `..\BingoAPI\docs\mobile-handoffs\` for every contract change; this assistant must consume them, update the relevant `lib/` files, tick rows here, and reply with the mobile commit hash. | – |
| 2025-01-09 | 0.0, 0.3-H | Added Step 0.0 (Flutter stable target), Step 0.3-H (HERE SDK pub.dev migration with detailed API diff), `core/maps/` to folder layout, D6+D7 decisions. Updated Phase 0 table and activity log. | – |
| 2025-01-09 | – | Initial creation: `.github/github-copilot-instructions.md`, `mobile-state.md`, `mobile-solution-fix.md`, `mobile-migration-status.md`. Confirmed Flutter 2 migration completed on `flutter-2-migration` (PR #88) → merged to `dev2x` → branched into `dev` (current development tip). | – |
