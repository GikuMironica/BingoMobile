# Hopaut Mobile – Migration Status

> Persistent progress tracker. **MUST be updated after every prompt that changes code, configuration, or migration documentation.**
>
> Companion to `mobile-playbook.md` (as-is analysis + target architecture + execution plan in one document).
>
> All work targets the **`dev`** branch (Flutter 2 line). `master` is frozen at `v1.2.17`.

**Legend**
- ⬜ not started
- 🟡 in progress
- ✅ done
- ❌ blocked (add reason)
- ⏭️ skipped (add reason)

**Current focus:** Phase 0 – Step 0.2 (widen SDK constraint and adopt null-safety).

---

## Phase 0 — Runtime upgrade & foundation

| #      | Step                                                          | Status | Date | Notes / commit |
|--------|---------------------------------------------------------------|--------|------|----------------|
| 0.0    | **Choose Flutter stable target** (Flutter 3.24.5; add `.fvmrc`) | ✅     | 2026-09-27 | Pinned `.fvmrc`; installed FVM 4.3.1; verified Flutter 3.24.5 / Dart 3.5.4 (Windows junction workaround for symlink privilege). Commit `e2a7027`. |
| 0.1    | Capture baseline (tag, deps tree, screenshots of top screens) | ✅     | 2026-09-27 | Tagged `75553a4` as `pre-flutter-3.24-baseline`; captured runtime, lockfile inventory, and dependency-resolution failure in `0f0b9fa`. Visual capture waived by user because UI/UX changes are out of scope. |
| 0.2    | Widen Dart SDK (`>=3.5.0 <4.0.0`) + adopt null-safety        | ⬜     |      |                |
| 0.3    | Upgrade Flutter SDK + plugin majors — Batches A–K (excluding HERE SDK) | ⬜ |      |                |
| 0.3-H  | **HERE SDK: replace vendored path plugin with pub.dev `here_sdk: ^4.22.0`**; fix 6 affected files; wrap in `core/maps/here_sdk_adapter.dart` | ⬜ |      |                |
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
| D7 | **HERE SDK version** | **`here_sdk: ^4.22.0` from pub.dev (Explore Edition)** — replaces vendored `path: plugins/here_sdk` | ⬜ |   |

---

## Activity log (newest first)

| Date | Step | Action | Commit |
|------|------|--------|--------|
| 2026-09-27 | 0.1 | User scoped migration work to architecture, structure, performance, code smells, and bugs with no UI/UX changes; visual baseline waived and Step 0.1 closed. | – |
| 2026-09-27 | 0.1 | Created the pre-Flutter-3.24 tag and dependency baseline; recorded the visual-baseline blocker after exhausting workspace, history, device, emulator, binary, release, store, and archive sources. | `0f0b9fa` |
| 2026-09-27 | 0.0 | Completed runtime pinning: corrected nonexistent `3.24.6` to Flutter `3.24.5`, installed FVM 4.3.1, and verified Flutter 3.24.5 / Dart 3.5.4. | `e2a7027` |
| 2026-09-27 | – | Consolidated the as-is analysis and execution plan into `mobile-playbook.md`, removed the legacy documents, and updated Copilot workflow references. | `e2a7027` |
| 2025-01-09 | – | **Tightened migration-workflow rules** in `C:\Users\ghmi\personal\BingoMobile\.github\github-copilot-instructions.md`: added exact file-path table for both status files (`C:\Users\ghmi\personal\BingoMobile\mobile-migration-status.md` and `C:\Users\ghmi\personal\BingoAPI\hopaut-migration-status.md`), added exhaustive trigger table (any code/config/doc/handoff change), added step-by-step "How to update" instructions (flip status → fill date → fill notes → prepend activity-log row). Mirrored tightening in backend instructions. | – |
| 2025-01-09 | – | Added *Backend ↔ Mobile contract sync* section to `.github/github-copilot-instructions.md`. Backend (`BingoAPI`) now produces handoff prompt files under `..\BingoAPI\docs\mobile-handoffs\` for every contract change; this assistant must consume them, update the relevant `lib/` files, tick rows here, and reply with the mobile commit hash. | – |
| 2025-01-09 | 0.0, 0.3-H | Added Step 0.0 (Flutter stable target), Step 0.3-H (HERE SDK pub.dev migration with detailed API diff), `core/maps/` to folder layout, D6+D7 decisions. Updated Phase 0 table and activity log. | – |
| 2025-01-09 | – | Initial creation: `.github/github-copilot-instructions.md`, `mobile-state.md`, `mobile-solution-fix.md`, `mobile-migration-status.md`. Confirmed Flutter 2 migration completed on `flutter-2-migration` (PR #88) → merged to `dev2x` → branched into `dev` (current development tip). | – |
