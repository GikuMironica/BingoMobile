# Hopaut Mobile – Playbook

> Single reference document: **as-is analysis** + **target architecture** + **phased execution plan**.
>
> Companion to `mobile-migration-status.md` (live step-by-step progress tracker — update it after every code or config change).
>
> All work targets the **`dev`** branch (Flutter 2 line). `master` is frozen at `v1.2.17`.

---

## Working contract

1. Resume work by attaching: `.github/github-copilot-instructions.md`, `mobile-playbook.md`, `mobile-migration-status.md`.
2. Trigger with `/migrate #mobile-playbook.md – continue from the next pending step in mobile-migration-status.md. Do exactly one step. Then update mobile-migration-status.md.`
3. After every step that changes code or configuration, **update `mobile-migration-status.md`** (mark the step done, add a one-line note + commit hash if applicable).
4. Never skip ahead more than one step without explicit user approval. Never run `flutter build` unless the user asks.
5. No step is "done" until `mobile-migration-status.md` is updated with: status (✅ / 🟡 / ❌), date, short note, optional commit hash.
6. Every new user-facing string lands in **both** `en.json` and `de.json`.
7. **UI/UX redesign is out of scope.** Preserve existing appearance and user flows; migration work targets architecture, code structure, performance, code smells, and bugs unless the user explicitly requests a UI/UX change.

---

## Part 1 — Current State (As-Is Analysis)

> Scope: the `dev` branch (Flutter 2 line) of the `BingoMobile` repository (logical product name *Hopaut*). Where relevant, divergences from `master` (Flutter 1, frozen at `v1.2.17`) are called out.

### 1.0 Branch / runtime topology

| Branch | Flutter | Dart SDK | State | Notes |
|---|---|---|---|---|
| `master` | 1.x | `^2.10.5` (no null-safety) | Frozen at tag `v1.2.17` | Last stable release before the Flutter 2 migration. Hotfix-only. |
| `flutter-2-migration` | 2.x | `^2.10.5` declared but Flutter-2 plugin set | Historical | The actual migration work landed here (commits like *"Migrate firebase"*, *"Fix here maps"*, *"Fix webview"*, *"Fixed the rest of the errors"*). |
| `dev2x` | 2.x | same | Historical | Received the merge of `flutter-2-migration` via PR #88. |
| `dev` | 2.x | same | **Current development tip** | Branched from `dev2x` after the migration was merged. Latest commits: *"Add page for location permission request"*, *"Add location permission popup, service"*, *"Attempt to fix account page"*. |

**The Flutter 2 migration was completed and merged into `dev`. All new architectural work targets `dev`.** `pubspec.yaml` on `dev` still declares `sdk: "2.10.5"` and the version is `1.1.0+17` — the SDK constraint is stale and must be widened to `>=2.12.0 <3.0.0` as part of Phase 0 to actually take advantage of null-safety.

Other notable branches in the remote (mostly merged or stale): `code-refactor`, `create-event-refactor`, `edit-event-refactor`, `event-refactor`, `Refactor/event-classification`, `optimization`, `finalizing`, `finishing-touches`, `migrate_presentation_account_announcements_authentication`, `minor-tweaks`, `refactor_password_validator`, `refactor_select_location_screen`, `settings_refactor`, `translations`, `update-dependencies`. These represent the historical "rolling refactor" approach and confirm the lack of a single coherent target architecture today.

---

### 1.1 High-level architecture (today)

The app is a **layered monolith inside one Flutter package** (`hopaut`) with weak boundaries between layers and *two parallel state-management approaches* coexisting.

```
main.dart
  └─ HopAut (StatefulWidget)
       └─ MaterialApp + MultiProvider (provider_list.dart)
            ├─ AuthenticationService          (ChangeNotifier, also owns identity refresh)
            ├─ SettingsProvider               (ChangeNotifier)
            ├─ AccountProvider                (ChangeNotifier, OTP timer, profile edits)
            ├─ ChangePasswordProvider
            ├─ SearchPageProvider
            ├─ EventProvider                  (ChangeNotifier, event list + create/edit + report)
            ├─ LocationServiceProvider
            ├─ MapLocationProvider
            ├─ ReportBugProvider
            └─ RatingProvider

   getIt (injectable) registers:
     services/  – AuthenticationService, DioService, OneSignalNotificationService,
                  SecureStorageService, FirebaseOtpService, LoggingService,
                  DateFormatterService
     repositories/ – Authentication, User, Event, Profile, Participant,
                     Announcement, Rating, Report, Tag (all extend abstract Repository)
     providers/  – every *Provider listed above

   fluro router
     ├─ /, /home, /login, /registration, /forgot_password
     ├─ /account, /account/edit, /account/edit/(picture|name|description|mobile|...), /change_password
     ├─ /settings, /tos, /privacy_policy, /imprint, /bug
     ├─ /event/:id, /create-event, /create-event/map, /rate-event/:id
     ├─ /edit-event, /edit-event/(description|title|tags|requirements|pictures|time|slots|price)
     ├─ /announcements, /announcements/:id, /announcements/user_list
     └─ /fullscreen_dialog
```

**Layers as they actually exist on disk**

* `lib/main.dart` – Firebase + HERE SDK + `configureDependencies()` + `EasyLocalization` bootstrap.
* `lib/hopaut_app.dart` – `MaterialApp` root, fluro router config, **Hive bootstrap** (`Hive.initFlutter(); Hive.openBox('auth')`), reads cached identity, refreshes the JWT, refreshes the user profile.
* `lib/init.dart` – first frame after Hive bootstrap; routes to `/login` or `/home` based on `AuthenticationService.user`.
* `lib/provider_list.dart` – the `MultiProvider` provider list.
* `lib/config/`
  * `injection.dart` + generated `injection.config.dart` (registers ~28 dependencies).
  * `constants/` – `api.dart` (all REST paths), `theme.dart`, `constraint.dart`, `configurations.dart`, `web.dart` (web portal URLs).
  * `routes/` – `application.dart` (singleton `FluroRouter`), `routes.dart` (route strings), `handlers.dart` (per-route widget factories).
  * `dio_base_options.dart`, `currencies.dart`, `event_types.dart`, `constants.dart`.
* `lib/controllers/`
  * `blocs/` – feature blocs implemented with `flutter_bloc` 6.x: `login/`, `register/`, `forgot_password/`. Pattern: a base `BaseEvent` whose `handleEvent(state)` returns a `Stream<TState>`; the bloc just yields whatever the event yields. This is essentially **bloc-as-stream-pump** — the events themselves carry the logic, not the bloc.
  * `providers/` – `ChangeNotifier` providers for everything else (account, change-password, event, location x3, map, rating, report-bug, search, settings) plus `page_states/` (`base_form_status.dart`, `otp_timer_state.dart`).
* `lib/data/`
  * `domain/` – `coordinate.dart`, `login_result.dart`, `request_result.dart` (small value objects).
  * `models/` – wire models matching backend DTOs (`Post`, `Event`, `MiniPost`, `Picture`, `Location`, `User`, `Identity`, `Announcement`, `AnnouncementMessage`, `Rating`, `Report`, `Bug`, `Profile`, `SearchQuery`, `EventList`). All use **hand-written `fromJson`/`toJson`** with PascalCase keys to match the backend.
  * `repositories/` – Dio-based repositories extending the abstract `Repository` (which provides `dio` from `DioService` and `logger` from `LoggingService`). Each repo wraps Dio calls in `try/on DioError catch (e) { logger.e(...); return null; }` and selectively returns `RequestResult { isSuccessful, data, errorMessage }`.
* `lib/services/`
  * `DioService` – single Dio instance; constructor adds a `PrettyDioLogger` and an `InterceptorsWrapper` whose 401 branch tries to refresh the token but **does not actually replay the original request** (the replay code is commented `// TODO Repeat request, must be fixed`).
  * `AuthenticationService` – owns `Identity`, `User`, refresh-token flow, Hive write of identity, secure-storage of token + refresh, Facebook login wiring, OneSignal subscription. **Heaviest service in the app.**
  * `OneSignalNotificationService` – OneSignal init, permission prompts, in-focus handler, opened-handler (TODO comment for "use application.navigateTo…").
  * `SecureStorageService`, `FirebaseOtpService`, `LoggingService` (wraps `package:logger`), `DateFormatterService`.
* `lib/presentation/`
  * `screens/` organised by area: `account/`, `account/edit_account/`, `announcements/`, `authentication/`, `events/`, `events/create/`, `events/edit/`, `events/location/`, `report/`, `search/`, `settings/`.
  * `widgets/` reusable widgets per area: `announcements/`, `behaviors/`, `buttons/`, `create_event_form/`, `dialogs/`, `event_page/`, `fields/`, `hopaut_btm_nav_bar/`, `image_screen/`, `inputs/`, `logo/`, `text/`, `ui/`. There is a top-level `widgets.dart` barrel that re-exports common ones (e.g. `showNewErrorSnackbar`).
* `lib/utils/` – `date_time_from_seconds.dart`, `image_utilities.dart` (forces WEBP via `flutter_image_compress`), `rounding_decimals.dart`.
* `lib/generated/` – `easy_localization` codegen (`codegen_loader.g.dart`, `locale_keys.g.dart`).

**Architecture pattern verdict**

The app does not implement Clean Architecture, BLoC architecture, or any other named pattern consistently. What it actually is:

* **Service Locator + ChangeNotifier-based MVVM** for most features (Account, Event, Settings, Location, Rating, Report, Search).
* **Bloc 6.x with custom event-handles-state pattern** for auth flows only (Login, Register, Forgot Password).
* **Anaemic data models** (`Post`, `Event`, `User`, …) with public mutable fields and hand-rolled JSON.
* **Repositories** are thin wrappers over Dio with no abstraction (no interface, just a concrete class extending `Repository`).
* **Presentation reads providers via `Provider.of<T>`** in many widgets and via `getIt<T>()` in others — both styles coexist.

This is best described as a **layered ad-hoc architecture** with two parallel state-management styles. It works, but it makes feature ownership unclear and testing painful.

---

### 1.2 Strengths to preserve

* **DI is properly bootstrapped.** `get_it` + `injectable` codegen is solid; new services slot in cleanly.
* **i18n is mature.** `easy_localization` with codegen + `LocaleKeys` constants. Almost no hardcoded user-facing strings remain (a few `print` calls aside).
* **Centralised API path constants** (`lib/config/constants/api.dart`).
* **Single Dio instance** (`DioService`) with one logging interceptor.
* **Crashlytics breadcrumbs** are sprinkled throughout `main.dart` / `hopaut_app.dart` and provide useful boot-time tracing.
* **Hive cache for identity** survives cold starts without re-login.
* **Image upload pipeline** consistently runs through `lib/utils/image_utilities.dart` (WEBP + `image_picker` + `image_cropper`) — easy to swap.
* **OneSignal external user id** is bound to the backend `UserId` claim, so push targeting Just Works.
* **HERE SDK** is vendored under `plugins/here_sdk` and bootstrapped from `main.dart`.
* **Dual-locale (en/de) is real** with translations under `assets/translations/`.

---

### 1.3 Flaws, anti-patterns, smells

#### 3.1 State management — split brain

* `flutter_bloc` 6.x is used **only for auth** (`login`, `register`, `forgot_password`). Everywhere else uses `ChangeNotifier` providers.
* The bloc pattern itself is unusual: `mapEventToState` is a one-liner `yield* event.handleEvent(state);` — meaning **events own the logic**, not the bloc. This makes it impossible to reason about a feature by reading the bloc class alone; you must enumerate every event class.
* `provider` + `ChangeNotifier` is fine for small features but is applied to "god providers" like `EventProvider` (which holds the event map, the current `Post`, location validity, date validity, two `BaseFormStatus` fields, *and* report-post status) and `AccountProvider` (which owns OTP timer, profile edit form status, name/photo updates, *and* SMS/Firebase auth side-effects).

#### 3.2 `AuthenticationService` is a god object

`lib/services/authentication_service.dart` has direct knowledge of:

* `SecureStorageService`, `DioService`, `OneSignalNotificationService`.
* `UserRepository`, `AuthenticationRepository`.
* `Hive.box('auth')`.
* JWT decoding (`jwt_decode`).
* Identity persistence + refresh flow.
* User profile fetch + caching.
* Facebook login wiring.
* It is also a `ChangeNotifier` exposed via `MultiProvider`.

This couples auth, persistence, push subscription and HTTP into one class. Any future change (e.g. switch to Firebase Auth, refresh queueing, multi-account) touches all of it.

#### 3.3 Token refresh interceptor is broken-by-design

`lib/services/dio_service.dart` 401 branch:

```dart
if (error.response?.statusCode == 401) {
  // ...
  await authService.refreshToken();
  // TODO Repeat request, must be fixed
  //  return await _dio.request(requestOptions.path);
}
```

The original failing request is **never replayed**. The user-visible effect is that the *next* manual interaction after a silent refresh succeeds, but the action that triggered the 401 is silently dropped. There is also no concurrency control: N parallel 401s will trigger N refresh calls.

#### 3.4 Repositories swallow errors and lose context

Every repository follows the pattern:

```dart
try {
  Response response = await dio.get(...);
  if (response.statusCode == 200) return Post.fromJson(...);
} on DioError catch (e) { logger.e(e.message); }
return null;
```

* The caller cannot distinguish *network failure* from *404* from *malformed response*. It only sees `null`.
* `RequestResult` is used for write paths but **only** carries an `errorMessage` string keyed on a few HTTP status codes (`400`, `403`). All other errors collapse into a generic `noConnection` translation key.
* Status codes 401, 429, 5xx are inconsistently handled across repos.

#### 3.5 Hand-written JSON

Every model class has hand-rolled `fromJson` / `toJson` with PascalCase keys:

```dart
Event.fromJson(Map<String, dynamic> json) {
  id = json['Id'];
  description = json['Description'];
  // ...
  eventType = EventType.values[(json['EventType'])];
}
```

* No null-safety on the values (e.g. `EventType.values[json['EventType']]` will crash if the backend ever sends a new enum value or a `null`).
* `toJson` writes mutable defaults (e.g. `currency.index` will throw `NoSuchMethodError on null` if currency was not set).
* Easy to drift from the backend contract — there is no compile-time check that a renamed backend field is reflected here.

#### 3.6 Routing on string literals

`fluro` 1.7 uses string routes (`/edit-event/description`, `/event/:id`). Navigation is `Application.router.navigateTo(context, '/event/$id', transition: ...)`. Compile-time safety is zero; refactoring a route string is a search-and-replace. Deep-link-friendliness is limited.

#### 3.7 Anaemic models with public mutable fields

`Post`, `Event`, `User`, `Picture`, etc. have **public mutable fields** with no invariants. Examples:

* `Post.activeFlag` is an `int` — no enum, no clamping.
* `Event.eventType` and `Event.currency` are public; nothing prevents `event.currency = null` followed by `toJson()` crashing.
* `Post.toMultipartJson` mutates the `data` map and accesses `this.event.entrancePrice` without null checking.

#### 3.8 Date math on Unix seconds everywhere

The backend currently returns event/post times as **Unix seconds (`Int64`)** (it will move to `DateTimeOffset` per the backend plan). The mobile parses them via `lib/utils/date_time_from_seconds.dart`. Once the backend migrates, every parser must be touched. There is no central abstraction.

#### 3.9 Navigation from inside `build()`

`init.dart` performs `Future.delayed(Duration(milliseconds: 1), ...)` from inside `build()` to navigate. This is the well-known anti-pattern of "I need to navigate after first frame", and it's unguarded against rebuilds — every rebuild of `Initialization` schedules another navigation.

#### 3.10 Hive bootstrap inside `MaterialApp.home`'s `FutureBuilder`

`hopaut_app.dart` does `Hive.initFlutter(); Hive.openBox('auth')` inside the `home: FutureBuilder(...)` of the root `MaterialApp`. This couples persistence bootstrap to the widget tree, re-runs on hot reload, and leaves no place to fail gracefully if Hive throws.

#### 3.11 Non-lazy heavyweight providers

Some providers are `lazy: true` (good) and some are not (`AuthenticationService`, `SettingsProvider`, `AccountProvider`, `LocationServiceProvider`). For app start latency this means OneSignal init, Geolocator wiring, and similar happen during the first frame.

#### 3.12 No tests of substance

`test/` contains the default Flutter widget test scaffold; there are no tests for blocs, providers, repositories or critical flows (login, create event, attendance). Crash data is the only feedback loop today.

#### 3.13 `print` calls in production code

`lib/config/routes/routes.dart` has a `print('Error: Route not found');` in the `notFoundHandler`. Crashlytics breadcrumbs are used elsewhere but not consistently.

#### 3.14 Mixed snackbar / toast / dialog conventions

* `Fluttertoast.cancel(); showNewErrorSnackbar(...)` in `DioService`.
* Custom `showNewErrorSnackbar` helper exported from `presentation/widgets/widgets.dart`.
* Some dialogs use `presentation/widgets/dialogs/custom_dialog.dart`, others build inline.

There is no single `SnackbarService` or `DialogService`, so toasting style drifts.

#### 3.15 Multipart upload is ad-hoc per repository

`EventRepository.create` mutates `dio.options.headers` to swap to `multipart/form-data`, performs the upload, then reverts in `finally`. If two multipart uploads race, the header state is undefined. The conversion lives in `Post.toMultipartJson(bool isUpdate)`, mixing transport concerns into the model.

#### 3.16 Stale SDK constraint

`pubspec.yaml` still declares `sdk: "2.10.5"` even though `dev` is on the Flutter 2 line. This blocks adopting null-safety. It must be widened to `>=2.12.0 <3.0.0` (or higher) and the codebase migrated through `dart migrate`.

#### 3.17 Dependency drift

`flutter_bloc 6.1.3`, `provider 4.3.2`, `dio 3.0.9`, `hive 1.4.4`, `firebase_core 0.7.0`, `image_picker 0.6.7`, `flutter_secure_storage 3.3.3`, `intl 0.16.1`, `geolocator 6.2.1`, `flutter_facebook_auth 2.0.2`, `onesignal_flutter 2.6.4`, `easy_localization 2.3.3` — all are **multiple major versions behind** their current releases. Each upgrade has its own breaking changes (especially `dio 4→5`, `flutter_bloc 6→8`, `firebase_* 0.7→latest`, `image_picker 0.6→1.x`, `secure_storage 3→9`, `provider 4→6`, `geolocator 6→11`, `onesignal_flutter 2→5`, `easy_localization 2→3`, `intl 0.16→0.19`).

#### 3.17-H HERE SDK — vendored path plugin (critical)

The HERE SDK for Flutter (Explore Edition) is referenced as a **local path plugin**:

```yaml
here_sdk:
  path: plugins/here_sdk
```

The `plugins/here_sdk` folder **does not exist in the repository** — it is gitignored and must be downloaded manually from the HERE developer portal and placed before every fresh checkout. This means:

* **The app cannot be built by anyone without manual SDK download.** No CI, no new team member can build without extra steps.
* The specific version that was vendored is unknown (circa 4.0–4.5 based on the API used: `SdkContext.init(IsolateOrigin.main)`, `MapScheme.greyDay`, synchronous `loadSceneForMapScheme` callback style — all removed or changed in pub.dev 4.13+).
* `here_sdk` is available on **pub.dev** as of version 4.x (Explore Edition). The correct target for Flutter 3.24.x / Dart 3.5 is `here_sdk: ^4.22.0`.
* **6 files use HERE SDK APIs:** `main.dart`, `map_location_provider.dart`, `search_page_provider.dart`, `map.dart` (location picker screen), `search.dart`, `search_carousel.dart`.
* The HERE API key must come from `--dart-define=HERE_API_KEY=...` — **not hardcoded**.
* **API surface breaking changes from vendored → 4.22:**
  * `SdkContext.init(IsolateOrigin.main)` → `SDKNativeEngine.makeSharedInstance(SDKOptions.withApiKey(key))`.
  * `mapScene.loadSceneForMapScheme(scheme, callback)` → `await mapScene.loadSceneForMapScheme(scheme)` (async, no callback).
  * `MapScheme.greyDay` → `MapScheme.normalDay` (renamed in 4.13).
  * `MapSceneLayers` → verify; in some 4.x versions moved to `MapSceneLayer` (no trailing `s`).

#### 3.18 Discontinued packages

* `flutter_webview_plugin: 0.3.11` was deprecated long ago in favour of `webview_flutter`.
* `geocoder: 0.2.1` is unmaintained since 2019; it must be replaced with `geocoding`.

#### 3.19 No CI configured

There is no `.github/workflows/` in the repo. No automated `flutter analyze` / `flutter test` / `dart format --set-exit-if-changed`.

#### 3.20 Hardcoded production base URL

`lib/config/constants/api.dart` has `static const String API_ROOT_URL = 'https://hopout.eu/api/v1';` — a debug build hits production. There is no env-based switching.

---

### 1.4 Risk heatmap

| Risk | Likelihood | Blast radius | Today's mitigation |
|---|---|---|---|
| Token-refresh interceptor drops the failing request → user sees a blank screen | high | moderate (UX) | none |
| `Event.fromJson` throws on a new backend `EventType` enum value | high | high (whole Post rendering crashes) | Crashlytics catches it post-mortem |
| Backend switches from Unix seconds to `DateTimeOffset` | inevitable | high (every screen showing dates) | none — every parser must be touched |
| Backend ProblemDetails rollout changes error envelopes | inevitable | medium (every error toast may show fallback i18n) | none |
| Concurrent multipart uploads race on shared `dio.options.headers` | medium | low–medium | the `finally` clause; not guaranteed |
| `Hive.initFlutter` failure in `MaterialApp.home` future → infinite spinner | low | high | none |
| Stale plugin major versions block Android/iOS publishing later (especially Firebase) | high | high | none — has to be done eventually |
| Discontinued packages (`flutter_webview_plugin`, `geocoder`) stop building on new Flutter SDKs | inevitable | medium | none |
| Production URL pinned in code → test/staging traffic hits prod | medium | high | none |
| No CI → bad code lands in `dev` | high | medium | manual review only |

---

### 1.5 Dependency graph (high-level, today)

```
main.dart
  Firebase ─┐
  HERE SDK ─┤
  configureDependencies (get_it/injectable) ─┐
                                              │
EasyLocalization (assets/translations) ──────►│
                                              ▼
                                          HopAut
                                              │
                                  ┌───────────┴───────────┐
                                  │                       │
                            MultiProvider             FutureBuilder
                            (provider_list)           (Hive bootstrap +
                                  │                    refreshToken +
                                  │                    refreshUser)
                                  ▼
              ┌──────────────────────────────────────┐
              │  ChangeNotifier providers            │
              │  flutter_bloc Blocs (auth only)      │
              │  Services (Dio, Auth, OneSignal,…)   │
              │  Repositories (Dio-based)            │
              └──────────────────────────────────────┘
                                  │
                                  ▼
                      Backend REST API (BingoAPI)
                              + S3 (pictures via URL)
                              + OneSignal (push)
                              + HERE Maps (in-app)
                              + Firebase Auth (OTP)
                              + Facebook Graph (login)
```

---

## Part 2 — Target Architecture

### 2.1 Guiding principles

1. **Feature-first folders, layers inside.** Each feature owns its `domain`, `data`, `presentation`. Cross-cutting infrastructure lives under `core/`.
2. **Single state-management approach.** Pick one of {BLoC v8 (Cubit-first) ; Riverpod 2.x} in Phase 1 and migrate all features to it. The `provider + ChangeNotifier` style and the Bloc-6.x "events-handle-state" pattern are both legacy.
3. **Domain is pure Dart.** No Flutter, no Dio, no Hive, no `flutter_bloc` imports inside `domain/`.
4. **Errors are values, not exceptions.** Repositories return `Result<T, AppFailure>` (sealed family). Throwing only happens at clearly defined boundaries (interceptors, isolates).
5. **Generated DTOs.** `freezed` + `json_serializable` for every wire model. Hand-written `fromJson`/`toJson` is forbidden in new code.
6. **Routing is typed.** `go_router` replaces `fluro`. Routes are constants returning `String` paths from typed parameters; navigation goes through `context.go(...)` / `context.push(...)`.
7. **Auth is a single source of truth.** Token refresh is queued; the original request is replayed; the refresh path is owned by an interceptor + a thin `AuthSession` value object — not a god `AuthenticationService`.
8. **Push, OTP, location, image processing are isolated services** under `core/` with feature code consuming small interfaces.
9. **Backend contract changes are absorbed at the DTO layer.** When the backend introduces ProblemDetails, async picture pipeline, or `DateTimeOffset`, only DTOs/mappers change; domain entities stay stable.
10. **CI enforces invariants.** `flutter analyze` (treat infos as errors for new code), `dart format --set-exit-if-changed`, `flutter test`, dependency-direction lint via `import_lint` (or `dart_code_metrics`).

### 2.2 Target folder layout

```
lib/
├── main.dart
├── app/
│   ├── hopaut_app.dart                # MaterialApp.router + theme
│   └── bootstrap.dart                 # Firebase, HERE, DI, EasyLocalization, Hive, Crashlytics
├── core/
│   ├── di/                            # get_it/injectable bootstrap (kept)
│   ├── network/
│   │   ├── dio_client.dart            # single Dio instance
│   │   ├── auth_interceptor.dart      # bearer header
│   │   ├── refresh_interceptor.dart   # queued 401 refresh + replay
│   │   ├── error_interceptor.dart     # DioError → AppFailure
│   │   └── problem_details.dart       # RFC-7807 parser
│   ├── error/
│   │   ├── app_failure.dart           # sealed class
│   │   └── result.dart                # Result<T,F>
│   ├── routing/
│   │   ├── app_router.dart            # GoRouter config
│   │   └── routes.dart                # typed route helpers
│   ├── storage/
│   │   ├── secure_storage.dart
│   │   └── hive_boxes.dart            # boxName constants + adapters
│   ├── auth/
│   │   ├── auth_session.dart          # value object (token, refresh, expiry, identity)
│   │   ├── auth_repository.dart       # interface
│   │   └── auth_service.dart          # orchestrator (login/logout/refresh/Facebook)
│   ├── notifications/
│   │   └── push_service.dart          # OneSignal wrapper
│   ├── maps/
│   │   ├── here_sdk_adapter.dart      # thin wrapper isolating HERE SDK API surface
│   │   └── map_config.dart            # HERE API key injection via AppEnvironment
│   ├── i18n/
│   │   └── easy_localization_setup.dart
│   ├── theme/
│   ├── observability/
│   │   ├── logger.dart                # package:logger wrapper
│   │   └── crashlytics_breadcrumbs.dart
│   └── env/
│       └── app_environment.dart       # dev/staging/prod via --dart-define
└── features/
    ├── authentication/                # login, register, forgot/change/add password, FB
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    ├── account/                       # profile read/edit, mobile confirmation (OTP)
    ├── events/                        # post listing, create, edit, view, delete, attendance
    ├── feed/                          # near-me feed (search by map + filters)
    ├── attendance/                    # accept/reject participation
    ├── announcements/
    ├── ratings/
    ├── moderation/                    # report post / report user
    ├── bug_reports/
    ├── settings/                      # privacy, ToS, imprint, push toggles, language
    └── home/                          # bottom nav + shell
```

### 2.3 Cross-feature contracts

* DTOs (`features/<x>/data/dto/`) are **internal** to each feature. If feature B needs a value from feature A, expose it as a domain entity through A's barrel, not as A's DTO.
* `core/auth/auth_session.dart` is the only place that reads/writes the JWT. Repositories and features never touch the storage layer for tokens.

### 2.4 Testing pyramid

| Layer | Tool | What |
|---|---|---|
| Unit (domain) | `flutter_test` | entities, value objects, use cases |
| Unit (data) | `flutter_test` + `mocktail` | repository mappers + impls against mocked Dio |
| State | `bloc_test` (or `riverpod_test`) | Cubits / Notifiers |
| Widget | `flutter_test` | screens with mocked state |
| Golden | `golden_toolkit` | a handful of high-traffic screens |
| Integration | `integration_test` | login, create event, attend, rate (against staging) |

### 2.5 Definition of done

The architecture migration is complete when:

1. The `dev` branch builds on the selected Flutter stable version with compatible stable plugin versions and no `pub` warnings.
2. Null-safety is enabled across the codebase.
3. There is **one** state-management approach (BLoC v8 *or* Riverpod 2) used consistently in `features/`.
4. Every feature follows the layered structure (`domain` / `data` / `presentation`) and is testable in isolation.
5. Repositories return `Result<T, AppFailure>`; no more silent `null`s.
6. JSON serialization is generated by `freezed` + `json_serializable`.
7. The Dio token-refresh interceptor queues concurrent 401s and replays the original request once.
8. Routing is type-safe via `go_router`.
9. The app starts in < 2s on a mid-range Android device and Hive bootstrap is no longer in the widget tree.
10. CI runs `flutter analyze`, `flutter test`, and `dart format --set-exit-if-changed` on every PR.
11. The app has at least one widget/integration test for each critical flow (login, create event, attend event, leave rating).
12. All hardcoded URLs / keys are environment-driven via `--dart-define`.
13. The mobile app supports the backend's async picture pipeline (`Pending → Ready` lifecycle) once it ships.

---

## Part 3 — Execution Plan

### Phase 0 — Runtime upgrade & foundation

> Goal: get the `dev` branch onto the selected **Flutter 3.24 stable line**, full null-safety, compatible current plugins (including a HERE SDK version delivered via pub.dev instead of a vendored path), env-based config, and CI.

> ⚠️ **HERE SDK note (read before starting 0.3).**
> Today the HERE SDK is referenced as a **local path plugin** (`path: plugins/here_sdk`). That folder is not committed to the repo — it must be manually downloaded and placed before any build. The migration target is the **pub.dev-published `here_sdk` package** (HERE Maps SDK for Flutter, Explore Edition). The version must be matched to the Flutter stable version chosen in Step 0.0:
>
> | Flutter stable release | Dart SDK | Compatible `here_sdk` (pub.dev) |
> |---|---|---|
> | Flutter 3.19.x (Feb 2024) | Dart 3.3 | `here_sdk: ^4.17.x` |
> | Flutter 3.22.x (May 2024) | Dart 3.4 | `here_sdk: ^4.20.x` |
> | Flutter 3.24.x (Aug 2024) | Dart 3.5 | `here_sdk: ^4.22.x` |
> | Flutter 3.27.x (Nov 2024) | Dart 3.6 | `here_sdk: ^4.23.x` |
>
> **Pinned migration target: Flutter 3.24.5**, the final official stable patch on the 3.24 line, with `here_sdk: ^4.22.0` from pub.dev. This removes the vendored-plugin anti-pattern entirely.
>
> The HERE Explore Edition requires a **HERE platform API key** (not an app-id/app-code pair). Supply it via `--dart-define=HERE_API_KEY=...` (see Step 0.4) and inject it via `SDKNativeEngine.makeSharedInstance(SDKOptions.withApiKey(AppEnvironment.hereApiKey))`.
>
> The API surface **did change** between the vendored version (circa 4.x early) and pub.dev 4.22:
> * `SdkContext.init(IsolateOrigin.main)` → `SDKNativeEngine.makeSharedInstance(SDKOptions.withApiKey(...))` (the old `SdkContext` class is removed in recent pub.dev releases).
> * `HereMapController.mapScene.loadSceneForMapScheme(MapScheme.xxx, callback)` → now async, returns `Future<void>`, callback removed.
> * `MapScheme` enum members renamed (`greyDay` → `normalDay` etc. in some versions — verify against the `4.22` changelog).
> * `SearchEngine` constructor is the same; `Place`, `GeoCoordinates`, `TextQuery`, `SearchOptions` are stable across 4.x.
> * `WatermarkPlacement` → `WatermarkPlacement.bottomRight` still exists.
> * `MapSceneLayers` / `MapSceneLayerState` → still valid.
>
> Affected files (6): `lib/main.dart`, `lib/controllers/providers/map_location_provider.dart`, `lib/controllers/providers/search_page_provider.dart`, `lib/presentation/screens/events/location/map.dart`, `lib/presentation/screens/search/search.dart`, `lib/presentation/screens/search/search_carousel.dart`.

#### Step 0.0 — Choose Flutter stable target
* **Goal:** lock the runtime we're building toward before any package upgrades.
* **Actions:**
  * Decide: **Flutter 3.24.5 stable / Dart 3.5** — record in `mobile-migration-status.md` Decisions table as D6.
  * Install the selected Flutter version locally (`fvm use 3.24.5`). Use FVM (Flutter Version Management) when multiple Flutter versions are needed across projects.
  * Add `.fvmrc` at repo root with `{ "flutter": "3.24.5" }` so CI and team members pick the same version.
  * Verify `fvm flutter --version` returns Flutter `3.24.5`.
* **Acceptance:** `.fvmrc` committed; `fvm flutter --version` returns Flutter `3.24.5` / Dart `3.5.x`.
* **Status:** `0.0`.

#### Step 0.1 — Capture baseline
* **Goal:** know what we're about to break.
* **Actions:**
  * Tag current `dev` HEAD as `pre-flutter-3.24-baseline`.
  * Save `flutter --version`, `dart --version`, `flutter pub deps --no-dev --style=tree` to `docs/baseline-deps.txt`.
  * Preserve the existing UI/UX. The originally planned screenshots of the 6 highest-traffic screens are waived by the user because UI/UX changes are outside this migration's scope.
* **Acceptance:** tag exists; dependency baseline committed; visual capture explicitly waived on 2026-09-27.
* **Status:** `0.1`.

#### Step 0.2 — Widen SDK + adopt null-safety
* **Actions:**
  * Update `pubspec.yaml`: `environment.sdk: ">=3.5.0 <4.0.0"` (matches Flutter 3.24.x / Dart 3.5).
  * Run `dart migrate --apply-changes` in passes (file-by-file for large files). For files that resist migration, add explicit `?` and `late` annotations. Add `// ignore_for_file: ` only with a TODO.
  * Fix all `flutter analyze` errors (warnings deferred to Step 0.6).
* **Acceptance:** `flutter analyze` returns 0 errors on the `dev` branch.
* **Status:** `0.2`.

#### Step 0.3 — Upgrade Flutter SDK + plugin majors (all except HERE SDK)
* **Actions:** in batches (revert if a batch breaks; commit each batch as its own commit):
  * **Batch A** (low-risk): `intl 0.16→0.19`, `logger`, `package_info → package_info_plus`, `shared_preferences`, `flutter_secure_storage 3→9`, `path_provider`.
  * **Batch B** (Bloc/Provider): `flutter_bloc 6→8`, `provider 4→6`.
  * **Batch C** (Networking): `dio 3→5` (`DioError → DioException`; `onError` callback signature changed), `pretty_dio_logger` (current).
  * **Batch D** (Storage): `hive 1→2` + `hive_flutter` (current). Re-run `hive_generator` for any adapted types.
  * **Batch E** (Firebase): `firebase_core`, `firebase_auth`, `firebase_crashlytics` to current major. Update `google-services.json` / `GoogleService-Info.plist` if needed.
  * **Batch F** (Media/UX): `image_picker 0.6→1.x` (`PickedFile → XFile`), `image_cropper`, `flutter_image_compress` (update `CompressFormat.webp` → verify same enum name), `cached_network_image`, `extended_image`, `carousel_slider`, `flutter_svg`, `animations`.
  * **Batch G** (Location): `geolocator 6→11` (permission flow changed), `permission_handler 5→11`, `location` (current), `geocoder → geocoding` (package name changed; all `Geocoder.local().findAddressesFromQuery(...)` calls rewritten to `GeocodingService().searchByAddress(...)` from the `geocoding` package).
  * **Batch H** (Auth/Push): `flutter_facebook_auth 2→6` (API breaking — `FacebookAuth.instance.login()` return type changed), `onesignal_flutter 2→5` (init API changed: `OneSignal.shared.init(...)` removed; now `OneSignal.initialize("app_id")`), `jwt_decode` (current).
  * **Batch I** (Webview): `flutter_webview_plugin → webview_flutter 4.x` (full replacement). Rewrite the `WebviewWidget` wrapper around `WebViewWidget` from the new package.
  * **Batch J** (i18n): `easy_localization 2→3`, update `assetLoader` usage (codegen API unchanged but `EasyLocalization.of(context)` removed in favour of context extension). Regenerate `LocaleKeys`.
  * **Batch K** (Other): `rxdart 0.24→0.28`, `injectable+injectable_generator` (current majors), `table_calendar 2→3`, `sliver_tools`, `ionicons`, `url_launcher`, `rating_dialog`, `store_redirect`, `currency_text_input_formatter`, `badges`, `timeago 2→3`.
* **Note:** `here_sdk` is **excluded from this step** — it has its own dedicated Step 0.3-H.
* **Acceptance:** `flutter pub get` clean; `flutter analyze` 0 errors; app boots on Android emulator and iOS simulator (without HERE map screens — those come in Step 0.3-H).
* **Status:** `0.3`.

#### Step 0.3-H — HERE SDK: replace vendored path plugin with pub.dev package
* **Goal:** eliminate the `path: plugins/here_sdk` anti-pattern; adopt `here_sdk: ^4.22.0` from pub.dev (Explore Edition, Flutter 3.24.x compatible).
* **Why this is its own step:** HERE SDK API surface changed between the vendored version (circa 4.0–4.5 era) and pub.dev 4.22. The 6 affected files need careful rewriting. Failing to compile breaks the build entirely; rushing it into Batch G would mask other errors.
* **Actions:**
  1. **Remove** the `here_sdk: path: plugins/here_sdk` entry from `pubspec.yaml`. Add `here_sdk: ^4.22.0`.
  2. **HERE developer account:** ensure a valid HERE Freemium or paid API key exists. Supply via `--dart-define=HERE_API_KEY=...` (see Step 0.4). Do **not** hardcode in code.
  3. **`lib/main.dart`** — replace:
     ```dart
     // OLD
     SdkContext.init(IsolateOrigin.main);
     // NEW (4.22.x)
     SDKNativeEngine.makeSharedInstance(
       SDKOptions.withApiKey(AppEnvironment.hereApiKey));
     ```
  4. **`lib/controllers/providers/map_location_provider.dart`** — update:
     * `_hereMapController.mapScene.loadSceneForMapScheme(mapScheme, callback)` → `await _hereMapController.mapScene.loadSceneForMapScheme(mapScheme)` (now returns `MapError?`, no callback).
     * `MapScheme.greyDay` → `MapScheme.normalDay` (name changed in 4.13+; verify against 4.22 changelog).
     * `_hereMapController.setWatermarkPosition(WatermarkPlacement.bottomRight, 10)` — verify signature still valid; if removed, delete the call.
     * `MapSceneLayers.extrudedBuildings` / `MapSceneLayerState.hidden` — verify names; may have moved to `MapSceneLayer` (no `s`).
  5. **`lib/presentation/screens/events/location/map.dart`** — `HereMap` widget import from `here_sdk/mapview.dart` is stable; verify `HereMapController` constructor callback param name (`onMapCreated` unchanged).
  6. **`lib/controllers/providers/search_page_provider.dart`** and **`search.dart` / `search_carousel.dart`** — `SearchEngine`, `GeoCoordinates`, `Place`, `TextQuery`, `SearchOptions` API is stable in 4.22; verify the callback style changed to async if needed.
  7. Wrap all HERE interactions in `core/maps/here_sdk_adapter.dart` so future HERE SDK upgrades only touch one file.
  8. **Android:** verify `minSdkVersion` in `android/app/build.gradle` is at least `21` (required by here_sdk 4.22).
  9. **iOS:** verify `platform: ios, '12.0'` (or higher) in `ios/Podfile` and that `ENABLE_BITCODE = NO` is set (HERE SDK requirement).
* **Acceptance:** map screen loads, user location can be found, a POI search returns results, location can be selected and returned to create-event form — all without the `plugins/here_sdk` folder on disk.
* **Status:** `0.3-H`.

#### Step 0.4 — Environment-driven configuration
* **Actions:**
  * Add `lib/core/env/app_environment.dart` reading `--dart-define`d values: `API_BASE_URL`, `ONESIGNAL_APP_ID`, `HERE_API_KEY`, `FACEBOOK_APP_ID`, `ENV` (`dev|staging|prod`).
  * Replace `lib/config/constants/api.dart#API_ROOT_URL` and the OneSignal id literal and the HERE API key with reads from `AppEnvironment`.
  * Add `flavors/dev.json`, `flavors/staging.json`, `flavors/prod.json` (or VS Code `launch.json` configs with `--dart-define-from-file`) supplying defaults per environment.
  * Add `.gitignore` entries for any `*.json` flavor files that contain secret key values.
* **Acceptance:** `flutter run --dart-define-from-file=flavors/dev.json` boots the app, hits the dev backend, and loads the HERE map — all without touching code.
* **Status:** `0.4`.

#### Step 0.5 — CI scaffolding
* **Actions:** add `.github/workflows/mobile-ci.yml` running `flutter pub get`, `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test` on every PR to `dev`. Cache pub.
* **Acceptance:** a sample PR runs the workflow green.
* **Status:** `0.5`.

#### Step 0.6 — Lint baseline
* **Actions:** add `analysis_options.yaml` extending `package:lints/recommended.yaml`. Add `dart_code_metrics` rules (`prefer-trailing-comma`, `avoid-non-null-assertion`, `prefer-const-constructors`). Configure `import_lint` rules to forbid `presentation/ → data/`.
* **Acceptance:** lint runs in CI; existing violations grandfathered with a `// ignore_for_file` block per legacy file (with TODO).
* **Status:** `0.6`.

#### Step 0.7 — Phase 0 exit gate
* **Actions:** verify all of: `0.0`–`0.6` ✅; analyze 0 errors; CI green; app boots; HERE map screen functional; baseline screens visually unchanged.
* **Status:** `0.7 — Phase 0 closed`.

---

### Phase 1 — Core foundations (no feature moved yet)

#### Step 1.1 — Pick state management (decision D1)
* **Actions:** record decision in this document §4 Decisions (BLoC v8 by default). Update `.github/github-copilot-instructions.md` "Target architecture rules" accordingly.
* **Acceptance:** decision committed.
* **Status:** `1.1`.

#### Step 1.2 — Create `core/` skeleton
* **Actions:** create empty folders + barrel files for `core/{di,network,error,routing,storage,auth,notifications,maps,i18n,theme,observability,env}`. Move `lib/services/logging_service.dart` → `core/observability/logger.dart`. Create `core/maps/here_sdk_adapter.dart` stub (thin wrapper; implementation from Step 0.3-H already complete).
* **Status:** `1.2`.

#### Step 1.3 — `Result<T, AppFailure>` + `AppFailure` sealed family
* **Actions:** implement `core/error/result.dart` (sealed `Result.success(T) | Result.failure(F)`) and `core/error/app_failure.dart` (`Network`, `Unauthorized`, `Forbidden`, `Validation(Map<String,List<String>>)`, `NotFound`, `RateLimited`, `Server`, `Unknown(message?)`). Add `failure_messages.dart` mapping each variant to a `LocaleKeys` entry.
* **Acceptance:** unit tests cover every variant + mapping.
* **Status:** `1.3`.

#### Step 1.4 — `DioClient` + interceptor stack
* **Actions:**
  * `core/network/dio_client.dart` constructs the single `Dio` from `AppEnvironment`.
  * `core/network/auth_interceptor.dart` adds the bearer token from `AuthSession`.
  * `core/network/refresh_interceptor.dart`: on 401, **enqueues** the failing request, calls `AuthService.refresh()` once (single-flight via a `Completer`), then replays the queued requests with the new token. On refresh failure → `AuthService.logout()` + emit `Unauthorized`.
  * `core/network/error_interceptor.dart`: maps `DioError` (and the new `DioException` after Dio 5) → `AppFailure` (parses RFC-7807 ProblemDetails when `Content-Type: application/problem+json`, falls back to legacy `SingleError`/`AuthFailedResponse` shapes during the backend transition).
* **Acceptance:** unit test simulates a 401 storm (5 concurrent calls) → exactly 1 refresh, 5 replays.
* **Status:** `1.4`.

#### Step 1.5 — `AuthSession` + `AuthService` + secure storage
* **Actions:**
  * `core/auth/auth_session.dart` — immutable value object (`token`, `refreshToken`, `expiresAt`, `identity`).
  * `core/auth/auth_repository.dart` (interface) + impl wrapping the new `DioClient`.
  * `core/auth/auth_service.dart` — orchestrator owning `AuthSession?`, `login/logout/refresh/loginWithFacebook/persistFromHive/restoreFromHive`. Replaces the god `AuthenticationService`.
  * `core/storage/secure_storage.dart` keys: `auth.token`, `auth.refresh`. `core/storage/hive_boxes.dart` constants `auth`, `settings`.
* **Acceptance:** existing login flow works against the new service via a thin shim from `lib/services/authentication_service.dart` (which becomes a delegating wrapper during transition).
* **Status:** `1.5`.

#### Step 1.6 — `go_router` replacing `fluro`
* **Actions:**
  * Add `go_router`. Define `core/routing/app_router.dart` with all current routes + a `redirect` based on `AuthService.session != null`.
  * Replace `Application.router.navigateTo(...)` callsites incrementally — start by routing the auth flows.
  * Remove `fluro` once every route migrated.
* **Acceptance:** every route reachable; deep links work (`hopaut://event/123`).
* **Status:** `1.6`.

#### Step 1.7 — `freezed` + `json_serializable` baseline DTOs
* **Actions:** add the packages, set up `build_runner` config, regenerate. Do **not** rewrite all models yet — just prove it works on one DTO (`AuthLoginResponseDto`).
* **Status:** `1.7`.

#### Step 1.8 — Move bootstrap out of widget tree
* **Actions:**
  * Create `app/bootstrap.dart` that runs Firebase init, HERE init, DI, `EasyLocalization`, Hive, Crashlytics, `AuthService.restoreFromHive()`. Returns a `BootstrapResult` (success or fatal-error info).
  * `main.dart` becomes ~10 lines: `bootstrap()` then `runApp(HopAutApp(bootstrap))`.
  * `hopaut_app.dart` no longer runs `Hive.initFlutter()` from a `FutureBuilder`. The router redirect handles "logged in vs not".
* **Acceptance:** cold start time measured and ≤ baseline; no Hive usage in widget `build()`.
* **Status:** `1.8`.

#### Step 1.9 — Phase 1 exit gate
* **Actions:** decision recorded; `core/` populated; `Result<T,F>` and `AppFailure` in use by at least one repository; auth replays a 401 once; routing on `go_router`; bootstrap moved; CI green.
* **Status:** `1.9 — Phase 1 closed`.

---

### Phase 2 — Authentication feature migration (template feature)

> Goal: prove the target architecture by migrating Authentication end-to-end. It becomes the template every other feature follows.

#### Step 2.1 — Scaffold `features/authentication/`
* **Actions:** create `domain/{entities,repositories,usecases}`, `data/{dto,mappers,repositories,sources}`, `presentation/{cubits,screens,widgets}`. Add a barrel `authentication.dart`.
* **Status:** `2.1`.

#### Step 2.2 — Domain
* **Actions:** entities `AuthCredentials`, `AuthSession`, `Identity`. Use cases: `LoginWithEmailUseCase`, `LoginWithFacebookUseCase`, `RegisterUseCase`, `ForgotPasswordUseCase`, `ChangePasswordUseCase`, `AddPasswordUseCase`, `LogoutUseCase`, `RefreshSessionUseCase`. Each use case takes a repository and returns `Future<Result<...>>`.
* **Status:** `2.2`.

#### Step 2.3 — Data
* **Actions:** DTOs (`LoginRequestDto`, `LoginResponseDto`, `RegisterRequestDto`, `RefreshRequestDto`, `RefreshResponseDto`, `FacebookLoginRequestDto`) generated by `freezed` + `json_serializable`. Mappers DTO ↔ Domain. `AuthRemoteDataSource` (Dio). `AuthRepositoryImpl` returning `Result<...>`.
* **Status:** `2.3`.

#### Step 2.4 — Presentation
* **Actions:** Cubits `LoginCubit`, `RegisterCubit`, `ForgotPasswordCubit`, `ChangePasswordCubit`, `AddPasswordCubit`. Screens use `BlocConsumer` with `BlocListener` for snackbar/navigation side-effects. Replace the existing bloc-6 `event.handleEvent(state)` pattern with explicit cubit methods.
* **Status:** `2.4`.

#### Step 2.5 — Wire DI + replace legacy `AuthenticationService` consumers
* **Actions:** annotate the new classes with `@injectable`/`@lazySingleton`; rerun `build_runner`. Replace every `getIt<AuthenticationService>()` callsite that does pure auth work; for code that still wants a `ChangeNotifier` (legacy widgets), expose a thin adapter.
* **Status:** `2.5`.

#### Step 2.6 — Tests
* **Actions:** unit tests for use cases + mappers; cubit tests with `bloc_test`; one widget test per screen; one integration test for the happy login path.
* **Status:** `2.6`.

#### Step 2.7 — Phase 2 exit gate
* **Status:** `2.7 — Phase 2 closed`.

---

### Phase 3 — Account, Settings, Notifications

> Lower-risk features migrated next; they exercise the template.

| #   | Step                                                                | Status |
|-----|---------------------------------------------------------------------|--------|
| 3.1 | Scaffold `features/account/` + migrate Account/Profile/EditProfile + OTP confirmation | ⬜ |
| 3.2 | Scaffold `features/settings/` + migrate Settings, push toggles, language | ⬜ |
| 3.3 | Move `OneSignalNotificationService` → `core/notifications/push_service.dart` (unify init, permission, external user id sync to `AuthSession`) | ⬜ |
| 3.4 | Replace `geocoder` with `geocoding` everywhere | ⬜ |
| 3.5 | Replace `flutter_webview_plugin` with `webview_flutter` | ⬜ |
| 3.6 | Phase 3 exit gate | ⬜ |

---

### Phase 4 — Events, Feed, Attendance, Ratings, Announcements (the heart)

> The feature group most affected by the backend refactor. Done together so the backend DTO changes land in lock-step.

| #    | Step | Status |
|------|------|--------|
| 4.1  | Scaffold `features/events/`; migrate event detail, create event, edit event sub-screens | ⬜ |
| 4.2  | Replace hand-written `Post`/`Event`/`MiniPost`/`Picture`/`Location` with `freezed` DTOs + domain entities | ⬜ |
| 4.3  | Implement async picture pipeline support: optimistic `Pending` placeholders + polling `GET /posts/{id}` for `Ready` | ⬜ |
| 4.4  | Move multipart upload into `EventRemoteDataSource` (no more `dio.options.headers` mutation in repos) | ⬜ |
| 4.5  | Scaffold `features/feed/`; migrate near-me feed + map search; cursor-based pagination ready for backend | ⬜ |
| 4.6  | Scaffold `features/attendance/`; migrate request / accept / reject / cancel | ⬜ |
| 4.7  | Scaffold `features/ratings/`; migrate leave-rating screen + read | ⬜ |
| 4.8  | Scaffold `features/announcements/`; migrate inbox/outbox + per-post announcements | ⬜ |
| 4.9  | Adopt `DateTimeOffset` parsing once the backend ships; remove `lib/utils/date_time_from_seconds.dart` | ⬜ |
| 4.10 | Phase 4 exit gate | ⬜ |

---

### Phase 5 — Moderation, Bug Reports, Home shell

| #   | Step | Status |
|-----|------|--------|
| 5.1 | Scaffold `features/moderation/`; migrate report-post + report-user | ⬜ |
| 5.2 | Scaffold `features/bug_reports/`; migrate bug submission incl. screenshot upload | ⬜ |
| 5.3 | Scaffold `features/home/`; migrate `HomePage` + bottom nav into a shell route (`StatefulShellRoute.indexedStack` from `go_router`) | ⬜ |
| 5.4 | Phase 5 exit gate | ⬜ |

---

### Phase 6 — Cleanup & hardening

| #   | Step | Status |
|-----|------|--------|
| 6.1 | Delete `lib/controllers/`, `lib/services/`, `lib/data/` once empty; the `lib/config/` shrinks to `core/env`, `core/theme` and is removed | ⬜ |
| 6.2 | Tighten lint rules: forbid `Provider.of` outside `core/`, forbid `getIt<>()` inside widget `build()` | ⬜ |
| 6.3 | Add golden tests for top 6 screens (regression net) | ⬜ |
| 6.4 | Add integration tests for: login, create event with images, attend event, leave rating | ⬜ |
| 6.5 | Performance pass: cold-start measurement, list scroll perf, image cache tuning | ⬜ |
| 6.6 | Definition-of-Done check vs §2.5 of this document | ⬜ |
| 6.7 | Cut a release tag `v2.0.0` from `dev` and merge to `master` | ⬜ |

---

## Part 4 — Decisions Log

| ID | Decision | Default | Locked-in? | Date |
|----|----------|---------|-----------|------|
| D1 | State management | BLoC v8 (Cubit-first) | ⬜ | |
| D2 | DTO codegen | `freezed` + `json_serializable` | ⬜ | |
| D3 | Routing | `go_router` | ⬜ | |
| D4 | HTTP | `dio` 5.x | ⬜ | |
| D5 | Result type | hand-rolled sealed class | ⬜ | |
| D6 | **Flutter version target** | **Flutter 3.24.5 stable / Dart 3.5** | ✅ | 2026-09-27 |
| D7 | **HERE SDK version** | **`here_sdk: ^4.22.0` from pub.dev (Explore Edition)** — replaces vendored `path: plugins/here_sdk` | ⬜ | |

Decisions D1–D5 are confirmed during Phase 1.1 and Phase 2. D6 and D7 are confirmed during Phase 0.0 and 0.3-H respectively.

**Open considerations**

* **D1** — BLoC v8 vs Riverpod 2. Default recommendation: **BLoC v8 (Cubit-first)** because half the codebase already uses `flutter_bloc`. Riverpod is a perfectly valid alternative if the team prefers it.
* **D2** — `freezed` vs `dart_mappable`. Recommendation: `freezed` (mature, ubiquitous).
* **D3** — `go_router` vs `auto_route`. Recommendation: `go_router` (first-party, simpler config).
* **D4** — `dio` vs `http`. Recommendation: stay on `dio` (interceptors, multipart, file upload progress all already used).
* **D5** — Result type: `dartz` `Either<L,R>` vs hand-rolled `sealed class Result<T,F>`. Recommendation: hand-rolled sealed class (Dart 3 sealed classes are perfect; avoids dartz weight).

---

## Part 5 — Cross-Phase Invariants

* No step is "done" until **`mobile-migration-status.md` is updated** with: status (✅ / 🟡 / ❌), date, short note, optional commit hash.
* Never run `flutter build` or `flutter run` for the whole app unless asked.
* When a step changes a public DTO, version-gate it behind a feature flag if mobile clients in production might call it.
* Every new feature must come with: at least one domain unit test, one repository test (mocked Dio), one cubit test, one widget test.
* Translations: every new user-facing string lands in **both** `en.json` and `de.json`.
* Preserve the current UI/UX and user flows unless the user explicitly requests a visual or interaction change.

---

## Part 6 — How to Resume Work

> Attach: `.github/github-copilot-instructions.md`, `mobile-playbook.md`, `mobile-migration-status.md`.
>
> Prompt: `/migrate #mobile-playbook.md – continue from the next pending step in mobile-migration-status.md. Do exactly one step. Then update mobile-migration-status.md.`
