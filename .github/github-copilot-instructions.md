# Copilot Instructions – Hopaut Mobile (BingoMobile)

At the start of every new conversation, explicitly mention the context you are using (files, configuration, environment) before answering. When writing production code, follow **Production code**. When writing tests, follow **Test code**. When refactoring toward the target architecture, follow **Target architecture rules**.

> Companion documents:
> * `mobile-playbook.md` – current-state analysis, target architecture, and executable migration plan.
> * `mobile-migration-status.md` – persistent progress tracker. **Must be updated after every prompt that changes code, configuration, or migration documentation.**

---

## General Rules

**IMPORTANT:** Do **NOT** run `flutter build` / `flutter run` automatically after every prompt. Only run when the user explicitly asks. Static checks (`flutter analyze`, `dart format --set-exit-if-changed .`) are fine.

**IMPORTANT:** UI/UX redesign is outside the migration scope. Preserve existing visuals and user flows; focus changes on architecture, code structure, performance, code smells, and bugs unless the user explicitly requests a UI/UX change.

**IMPORTANT:** The user maintains both `master` (Flutter 1, last release `v1.2.17`) and `dev` (Flutter 2, current development tip — branched off `dev2x` after PR #88 merged the `flutter-2-migration` work). **All new development happens on the Flutter 2 line (`dev` branch and feature branches off it).** Never apply a change to `master` unless the user explicitly asks for a hotfix.

When in doubt about which branch a file belongs to:
* `master` → Flutter 1.x, Dart 2.10, no null-safety, old plugin versions.
* `dev` (and `flutter-2-migration`, `dev2x`) → Flutter 2.x, Dart 2.12+, null-safety in progress, migrated plugins (firebase 0.7+, here_sdk, flutter_facebook_auth 2+, etc.).

---

## Migration Workflow (mandatory when working on the Clean Architecture refactor)

The refactor is governed by three persistent files at the repo root:

1. `.github/github-copilot-instructions.md` – this file (behavioral rules).
2. `mobile-playbook.md` – current-state analysis + target architecture + ordered phases/steps (the **playbook**).
3. `mobile-migration-status.md` – persistent progress tracker (the **state**).

### Status files — exact disk paths

| File | Absolute path |
|------|--------------|
| **Mobile status** | `C:\Users\ghmi\personal\BingoMobile\mobile-migration-status.md` |
| **Backend status** | `C:\Users\ghmi\personal\BingoAPI\hopaut-migration-status.md` |

### Rules

* Resume work by attaching all three files to the chat. The user will typically say `/migrate #mobile-playbook.md`.
* Always read `mobile-migration-status.md` first to determine the next pending step. Do **one step at a time** unless the user explicitly approves a batch.
* Follow the step exactly as defined in `mobile-playbook.md` (Goal / Actions / Acceptance criteria).

### ⚠️ MANDATORY AFTER EVERY PROMPT — NO EXCEPTIONS

**After _any_ prompt that produces _any_ of the following, you MUST update the relevant status file(s) before the response ends:**

| What changed | Which file(s) to update |
|---|---|
| Any Dart/Flutter source file added, edited, or deleted | `mobile-migration-status.md` |
| Any config file added or edited (`pubspec.yaml`, `analysis_options.yaml`, `*.json`, `.fvmrc`, `*.yaml`) | `mobile-migration-status.md` |
| Any migration documentation file edited (`mobile-playbook.md`, etc.) | `mobile-migration-status.md` |
| Consuming a backend handoff (`docs/mobile-handoffs/*.md`) that updates DTOs, routes, interceptors, or auth | `mobile-migration-status.md` + reply to user with mobile commit hash so backend handoff status can be flipped to `applied` |

**This rule applies to the very smallest change** — a single renamed field in a DTO, one package version bump in `pubspec.yaml`, adding one locale key. If _anything_ changed, the status file changes too.

### How to update the status file

For **every** qualifying prompt, perform **all four** of these actions in `mobile-migration-status.md`:

1. **Flip the step status** in the phase table:
   * `⬜` → `🟡` when work starts but is not finished.
   * `🟡` → `✅` when Acceptance criteria are met (or explicitly waived by the user).
   * `🟡` / `⬜` → `❌ <reason>` if blocked.
   * `⬜` → `⏭️ <reason>` if intentionally skipped with user approval.
2. **Fill in the Date column** (`YYYY-MM-DD`).
3. **Fill in the Notes / commit column** — one line: what was done and the git commit hash if available (write `–` if not yet committed).
4. **Prepend a new row to the Activity log table** at the bottom of the file:

   ```
   | YYYY-MM-DD | <step id or –> | <one-line description of what changed> | <commit hash or –> |
   ```

### When step cannot complete in one prompt

Mark the step `🟡` in progress. In the Notes column write: `in progress – <what remains>`. Return and finish it in the next prompt.

### Never

* Invent new phases/steps without proposing them to the user first. If approved, update `mobile-playbook.md` **and** `mobile-migration-status.md` in the same change.
* Tick a step `✅` unless its Acceptance criteria are demonstrably met or the user explicitly waives them.
* Skip updating the status file, even for trivial changes.

---

## Backend ↔ Mobile contract sync (mandatory)

The Hopaut backend (`BingoAPI`, sibling repo at `..\BingoAPI`) is the **only** server this app talks to. Any backend change that alters the observable HTTP / SignalR / auth contract is delivered as a **handoff prompt file** under `..\BingoAPI\docs\mobile-handoffs\YYYY-MM-DD-<phase>-<step>-<slug>.md`. The user pastes that file into the chat as the prompt. When that happens:

1. **Treat the handoff file as the source of truth** for the API change. Read its sections in order: *Source change*, *Affected endpoints*, *Wire-format diff*, *Behavioural diff*, *Backwards compatibility window*, *Required mobile changes*, *Suggested mobile validation*.
2. **Locate the right mobile layer** for each backend change:
   * DTO shape change → update `lib/data/models/<file>.dart` (legacy) or `lib/features/<feature>/data/dto/<file>.dart` (target, `freezed` + `json_serializable`). Regenerate codegen with `dart run build_runner build --delete-conflicting-outputs`.
   * Route added/changed → update `lib/config/api.dart` (legacy) or per-feature remote data source (target).
   * Status-code / error-envelope change → update the `DioService` / `DioClient` error interceptor and the `Result<T, AppFailure>` mapping.
   * Auth / refresh-token change → update `AuthenticationService` (legacy) / `AuthService` + `AuthSession` (target) and the 401 replay queue in the Dio interceptor stack.
   * Push payload change → update `core/notifications/push_service.dart` (target) or the OneSignal handler in `main.dart` (legacy).
   * Pagination / sorting / filtering change → update the corresponding repository + UI list controller.
   * Time format change (`Int64` Unix seconds → `DateTimeOffset` ISO-8601) → update parsers and remove `lib/utils/date_time_from_seconds.dart` once the last consumer is migrated (mobile Phase 4 / Step 4.9).
3. **Respect the backwards-compatibility window** declared in the handoff. If the backend serves both shapes, prefer the new one but keep the old parser until the window closes; raise the minimum supported app version only when the handoff says the old shape is removed.
4. **Update `mobile-migration-status.md`** in the same prompt:
   * Tick the relevant Phase/Step row(s) (or add a new row under the appropriate phase if the handoff produces work that does not fit existing steps — propose it to the user first).
   * Add an *Activity log* entry at the top: `<date> | handoff <filename> | <one-line summary> | <commit>`.
5. **Reply to the user with the mobile commit hash** so they can flip the handoff's *Status* section in `BingoAPI` from `pending` to `applied <date> <commit>`.
6. If the handoff is ambiguous (missing field, no example JSON, unclear compatibility window), do **not** guess — ask the user, and if needed request the backend assistant to amend the handoff file.

### Local i18n / UX rules when applying a handoff

* New backend error codes surfaced to the user **must** get a `LocaleKeys.*` entry in `assets/translations/*.json` (all locales, fallback to English copy with a TODO).
* Never display raw backend `code`/`message` strings to users.

### Cross-repo conventions to keep stable

* Wire DTO field names are `camelCase` and mirror the backend `Bingo.Contracts` / per-module `Contracts` projects 1:1.
* Routes are not inlined — they live in `lib/config/api.dart` (legacy) or per-feature remote data source constants (target).
* Time fields move from `Int64` seconds to ISO-8601 `DateTimeOffset` per-module as the backend ships each module migration. Keep both parsers available until the matching handoff is `applied`.

---

# Project Context

* **Product:** Hopaut – Flutter mobile app for a geosocial network (events near me, attendance, ratings, announcements, moderation, in-app purchases via the BingoAPI backend).
* **Repo:** `BingoMobile` (legacy on-disk name; logical product name is Hopaut).
* **Packaging name:** `hopaut` (`pubspec.yaml: name: hopaut`).
* **Backend:** sibling repo `BingoAPI` (see `Hopaut-Backend-State.md` / `hopaut-solution-fix.md` over there). Base URL is `https://hopout.eu/api/v1`. The mobile is a pure consumer of that REST API.
* **Current branch matrix (origin):**
  * `master` – Flutter 1, tag `v1.2.17`. Frozen.
  * `dev` – Flutter 2, current. Default working branch.
  * `flutter-2-migration`, `dev2x` – historical migration branches; do not start new work here.
* **Dart SDK:** `^2.10.5` on master; the `dev` migration target is Dart 3.5 / Flutter 3.24.5 stable in Phase 0.
* **State management today:** mixed — `flutter_bloc` 6.x for auth flows, `provider` + `ChangeNotifier` for everything else.
* **DI:** `get_it` + `injectable` (code-gen via `build_runner`).
* **Routing:** `fluro` 1.7 (string routes + global handlers).
* **HTTP:** `dio` 3.0.9 with `pretty_dio_logger` and a single `DioService` interceptor (token refresh on 401 is half-implemented and broken — see TODOs).
* **Storage:** `flutter_secure_storage` for tokens, `hive` for the cached identity payload, `shared_preferences` for user settings.
* **Auth:** JWT bearer + refresh token (Identity API), Facebook external login (`flutter_facebook_auth` 2.x), Firebase OTP for phone confirmation.
* **Maps / location:** `here_sdk` (currently vendored under `plugins/here_sdk` — **the folder is gitignored / not in repo**; target is pub.dev `here_sdk: ^4.22.0` per D7 in `mobile-migration-status.md`), `geolocator`, `location`, `permission_handler`, `geocoder`.
* **Push:** `onesignal_flutter` 2.x (matches the backend OneSignal app id).
* **i18n:** `easy_localization` (codegen loader at `generated/codegen_loader.g.dart`), JSON files under `assets/translations/`. **All user-facing strings must come from `LocaleKeys.*`** — never hardcode.
* **Crash reporting:** `firebase_crashlytics` (initialised in `main.dart`).
* **Image handling:** `image_picker` + `image_cropper` + `flutter_image_compress` (forces WEBP, see `lib/utils/image_utilities.dart`).

---

# Production code

## Today's stack (use what exists; do not add new patterns ad-hoc)

* Folder layout under `lib/`:
  * `config/` – constants (`api.dart`, `theme.dart`, `constraint.dart`, `configurations.dart`, `web.dart`), `injection.dart` + generated `injection.config.dart`, `dio_base_options.dart`, `routes/`.
  * `controllers/blocs/` – `flutter_bloc` features: `login/`, `register/`, `forgot_password/`. Pattern: `*_bloc.dart` + `*_event.dart` + `*_state.dart` + a per-feature `*_status.dart` enum. Base `BaseEvent.handleEvent(state)` returns the `Stream<TState>`.
  * `controllers/providers/` – `ChangeNotifier`-based providers (`AccountProvider`, `EventProvider`, `LocationServiceProvider`, `MapLocationProvider`, `RatingProvider`, `ReportBugProvider`, `SearchPageProvider`, `SettingsProvider`, `ChangePasswordProvider`, plus `legacy_location_provider.dart`). Internal sub-states under `controllers/providers/page_states/` (`base_form_status.dart`, `otp_timer_state.dart`).
  * `data/domain/` – internal value objects (`Coordinate`, `LoginResult`, `RequestResult`).
  * `data/models/` – wire models matching the backend DTOs (`Post`, `Event`, `MiniPost`, `Picture`, `Location`, `User`, `Identity`, `Announcement`, `Rating`, `Report`, `Bug`, `Profile`, `SearchQuery`, `EventList`).
  * `data/repositories/` – Dio-based repositories: `AuthenticationRepository`, `UserRepository`, `EventRepository`, `ProfileRepository`, `ParticipantRepository`, `AnnouncementRepository`, `RatingRepository`, `ReportRepository`, `TagRepository`. All extend the abstract `Repository` (gives them `dio` + `logger`).
  * `services/` – cross-cutting services (`DioService`, `AuthenticationService`, `OneSignalNotificationService`, `SecureStorageService`, `FirebaseOtpService`, `LoggingService`, `DateFormatterService`).
  * `presentation/screens/` – feature screens organised by area (`account/`, `announcements/`, `authentication/`, `events/`, `report/`, `search/`, `settings/`).
  * `presentation/widgets/` – reusable widgets per area (`buttons/`, `dialogs/`, `inputs/`, `event_page/`, `announcements/`, `hopaut_btm_nav_bar/`, `image_screen/`, `text/`, `ui/`, `behaviors/`, `create_event_form/`, `fields/`, `logo/`).
  * `utils/` – tiny helpers (`date_time_from_seconds.dart`, `image_utilities.dart`, `rounding_decimals.dart`).
  * `generated/` – `easy_localization` codegen + `LocaleKeys`.
  * `hopaut_app.dart` – `MaterialApp` root with `MultiProvider`, fluro router, Hive bootstrap.
  * `init.dart` – first frame after Hive bootstrap; routes to `/login` or `/home` based on `AuthenticationService.user`.
  * `provider_list.dart` – list of `MultiProvider` providers wired from `getIt`.
  * `main.dart` – Firebase + HERE SDK + DI + EasyLocalization bootstrap.

## Hard rules for new code in the legacy mobile app

1. **No new `print(...)`.** Use `getIt<LoggingService>().logger` (it's a `logger.Logger` from the `logger` package).
2. **No hardcoded user-facing strings.** Use `LocaleKeys.<area>.<key>.tr()`. If a key doesn't exist, add it to all locales under `assets/translations/`.
3. **No hardcoded URLs.** Routes in `lib/config/routes/routes.dart`, API paths as constants in `lib/config/constants/api.dart`. Backend host comes from `lib/config/dio_base_options.dart`.
4. **No business logic in `StatefulWidget` `setState`.** Mutations go through a provider (`ChangeNotifier`) or a bloc — never the widget itself.
5. **Repositories swallow `DioError` and return `null` / a `RequestResult`.** Keep this convention until Phase 2 of the mobile refactor moves errors to a `Result<T, AppFailure>`. **Do not throw across the repository boundary in new code.**
6. **`DateTime` from backend Unix seconds:** use `lib/utils/date_time_from_seconds.dart`. Never `DateTime.fromMillisecondsSinceEpoch(json[...])` ad-hoc. (When the backend migrates to `DateTimeOffset`, this util becomes obsolete; see `mobile-playbook.md` Phase 4.)
7. **Token refresh:** the only path that may set `Authorization` headers on Dio is `DioService`. Repositories must never read/write the bearer token directly.
8. **Image upload:** route through `lib/utils/image_utilities.dart` so the WEBP compression is consistent. Don't call `FlutterImageCompress` from screens.
9. **Dependency injection:** annotate new services / repositories / providers with `@lazySingleton` / `@singleton`, then run `flutter pub run build_runner build --delete-conflicting-outputs`. Never edit `injection.config.dart` by hand.
10. **No new `Provider.of<T>(context, listen: false)` deep inside widget trees** to read state from a separate feature. Inject the dependency through the constructor or `getIt`, or pass it explicitly.
11. **Async work on context-bound objects:** wrap `Application.router.navigateTo` calls in `Future.delayed(Duration(milliseconds: 1), ...)` only when transitioning out of a build phase (the existing pattern in `init.dart`). Otherwise navigate from event handlers.

## Naming conventions (current code)

* Files: `snake_case.dart`. One public class per file unless the secondary types are tightly coupled (e.g. an enum used only by that bloc).
* Classes: `PascalCase`. Bloc parts: `XxxBloc`, `XxxEvent`, `XxxState`, `XxxPageStatus`.
* Providers: `XxxProvider extends ChangeNotifier`.
* Repositories: `XxxRepository extends Repository`.
* Services: `XxxService` (often `@singleton`).
* Test files: mirror the source path under `test/` (currently sparse; will be filled out in Phase 5).

## ASP.NET-side contracts the mobile must respect

* JSON property names from the backend are **PascalCase** (`Token`, `RefreshToken`, `EventTime`, `Pictures`). All `*.fromJson` constructors must keep that casing. When the backend ProblemDetails migration ships, error parsing must accept both the old `SingleError`/`AuthFailedResponse` shapes **and** RFC-7807 `{type,title,status,detail,extensions}` until backend cleanup is done.
* Multipart uploads use field names of the form `Event.Title`, `UserLocation.Longitude`, `UpdatedEvent.Title` — see `lib/data/models/post.dart#toMultipartJson`. Do not change these names without coordinating with the backend.
* OneSignal external user id = the backend `UserId` claim. Set in `OneSignalNotificationService._initializeOneSignalSubscription`.

---

# Target architecture rules (apply when creating or refactoring a feature)

These rules are mandatory once the new layout from `mobile-playbook.md` is in place. Until then, follow the legacy rules above for files inside `lib/controllers/`, `lib/data/`, `lib/services/`, `lib/presentation/`.

## Layered structure (per feature)

```
lib/
├── core/                       # cross-cutting infrastructure (no feature logic)
│   ├── network/                # Dio client, interceptors, error mappers
│   ├── storage/                # secure storage, hive boxes
│   ├── routing/                # go_router or auto_route config
│   ├── di/                     # get_it/injectable bootstrap
│   ├── error/                  # AppFailure, Result<T,F>, exception mappers
│   ├── i18n/                   # easy_localization wiring
│   └── theme/
└── features/
    └── <feature>/
        ├── domain/             # entities (pure Dart), repository interfaces, use cases
        ├── data/               # DTOs, mappers, repository impl, data sources (remote/local)
        └── presentation/       # widgets, screens, controllers (BLoC v8 or Riverpod notifiers)
```

* `domain/` is pure Dart — no Flutter, no Dio, no Hive imports.
* `data/` depends on `domain/`. DTOs (`*Dto`) and entities (`*`) are distinct types; mappers translate between them.
* `presentation/` depends on `domain/` only. State holders (`XxxCubit` / `XxxNotifier`) call use cases, never repositories directly, never Dio directly.
* Cross-feature imports go through a feature's public `index.dart` barrel that exports only `domain/` types.

## State management

* New features use **`flutter_bloc` v8 (Cubit-first)** OR **Riverpod 2.x** — pick one in Phase 1 of `mobile-playbook.md` and stick with it. `provider` + `ChangeNotifier` is legacy.
* No global mutable state outside the chosen state container.
* Side effects (navigation, snackbars, dialogs) live in the widget layer and react to state changes via `BlocListener` / `ref.listen`.

## Routing

* Replace `fluro` with **`go_router`** in Phase 1. Routes are typed via `GoRoute` / `StatefulShellRoute`, deep-link-friendly, and aware of auth state via a redirect.

## Networking

* Single `DioClient` in `core/network/`, configured with the base URL, timeouts, interceptors (auth, retry, logging, ProblemDetails error mapping). Repositories receive `DioClient` via DI; never instantiate Dio.
* Token refresh interceptor must **queue concurrent 401s** and replay them after a single refresh call (today's broken pattern in `DioService`).
* Errors become `AppFailure` (`Network`, `Unauthorized`, `Forbidden`, `Validation(messages)`, `NotFound`, `RateLimited`, `Server`, `Unknown`). Repositories return `Result<T, AppFailure>` (e.g. via `dartz` or a small home-grown sealed class).

## Models / DTOs

* Use **`freezed` + `json_serializable`** for all DTOs and entities (immutable, `copyWith`, value equality, generated `fromJson`/`toJson`). The current hand-written `fromJson`/`toJson` is on the deprecation list.

## i18n

* All new strings go to `assets/translations/*.json`, regenerate with `easy_localization:codegen` (or its successor), use `LocaleKeys.<...>.tr()`. **Never** hardcode user-visible text.

## Async picture / post upload (matches backend Hangfire pipeline)

* When the backend rolls out the async picture pipeline (see backend `hopaut-solution-fix.md §6.13`), the mobile app must:
  1. POST `/posts` and receive `201 { postId, pictures: [{id, state: "Pending", placeholderUrl}] }` immediately.
  2. Show optimistic placeholders for each picture (blurred local file or `placeholderUrl`).
  3. Poll `GET /posts/{id}` (every 2s for max 30s) **or** subscribe to a OneSignal/SignalR push to flip placeholders to final URLs once `state == "Ready"`.
  4. If `state == "Failed"`, show a retry affordance that hits a future `POST /posts/{id}/pictures/retry`.

## Errors and snackbars

* No raw `Fluttertoast` calls scattered in widgets. Use the `showNewErrorSnackbar(...)` helper (already exists) for now; replace with a `SnackbarService` injected via DI in Phase 1 of the refactor.
* `AppFailure` → user-facing message mapping lives in `core/error/failure_messages.dart`, keyed off `LocaleKeys`.

## Dependency injection (target)

* Keep `get_it` + `injectable`. Annotate new classes (`@lazySingleton`, `@singleton`, `@injectable`). Keep `injection.config.dart` codegen.
* Constructor injection only. **No `getIt<T>()` calls inside widget `build()`** — inject through the widget constructor or read from the feature's BLoC/Notifier.

## Logging / observability

* `Logger` (package `logger`) for dev console output via `LoggingService`.
* `FirebaseCrashlytics` for production crash reporting + breadcrumbs.
* On 5xx / unexpected exceptions, send a non-fatal `Crashlytics.recordError(...)` with `correlationId` from the backend ProblemDetails response (when available).

## Performance

* Lists use `ListView.builder` / `SliverList` with stable keys, never `Column` of mapped widgets.
* Use `cached_network_image` for remote pictures (already a dependency); pre-cache after `pushNamed` to avoid white flashes.
* Wrap heavy computations (image decode/compress) in `compute(...)` / isolates.

---

# Test code

## Stack (target)

* `flutter_test` for widget tests.
* `bloc_test` for cubits/blocs.
* `mocktail` (preferred over `mockito` — no codegen) for mocking.
* `golden_toolkit` for golden tests on key screens.
* `integration_test` (in-tree) for full end-to-end flows against a staging backend.

## Stack (legacy `test/` until decommissioned)

* `flutter_test` only. Keep tests green during the refactor; do not add new test infra here.

## Test naming and structure

* Naming: `Given<precondition>_When<action>_Then<expected>`.
* `// Arrange`, `// Act`, `// Assert` blocks.
* One assertion concept per test.
* For widget tests, use `pumpAndSettle()` after navigation; never raw `await Future.delayed(...)`.

## Hard rules

* Do not change assertions or expected values unless the production code's observable output demonstrably changed.
* Do not redesign business logic to make a test pass.
* Preserve original test intent at all times.

## Test fix discipline

When fixing failing tests, fix **one test at a time**:

1. Run all tests, collect the full failure list.
2. Fix the first failing test.
3. Run only that test (`flutter test test/path/to/file.dart -p plain --name "Given..."`) and verify green before moving on.
4. After 3 consecutive failed fix attempts on the same test, report and move on.

---

# Quick reference – where things live today vs target

| Concern                | Today                                      | Target (`mobile-playbook.md`) |
|------------------------|--------------------------------------------|-----------------------------------|
| Routes                 | `lib/config/routes/routes.dart` + handlers | `lib/core/routing/` (`go_router`) |
| API endpoints          | `lib/config/constants/api.dart`            | unchanged (still constants) |
| HTTP client            | `services/dio_service.dart`                | `core/network/dio_client.dart` + interceptors |
| Models / DTOs          | `data/models/*.dart` (hand-written JSON)   | `features/<x>/data/dto/` (freezed + json_serializable) |
| Domain entities        | mixed into `data/models/`                  | `features/<x>/domain/entities/` (freezed) |
| Repositories           | `data/repositories/*.dart`                 | `features/<x>/data/repositories/` (impl) + `domain/repositories/` (interface) |
| Use cases              | inline in providers/blocs                  | `features/<x>/domain/usecases/` |
| State                  | mixed `provider` + `flutter_bloc` 6        | `flutter_bloc` v8 (Cubit-first) **or** Riverpod 2 (decide once) |
| DI                     | `config/injection.dart` + injectable       | `core/di/` (same toolchain) |
| Errors                 | repos return `null` / `RequestResult`      | `Result<T, AppFailure>` (sealed) |
| Push                   | `services/notifications_service.dart`      | `core/notifications/` |
| Storage                | `services/secure_storage_service.dart` + Hive bootstrap in `hopaut_app.dart` | `core/storage/` |
| i18n                   | `easy_localization` + `LocaleKeys` codegen | unchanged (move config under `core/i18n/`) |
| Crashlytics breadcrumbs| inline in `main.dart`/`hopaut_app.dart`    | `core/observability/` |
