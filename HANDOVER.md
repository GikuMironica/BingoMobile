# Handover – BingoMobile: frontend tasks to stay in sync with the backend

**Updated:** 2026-11-23 · **Mobile:** `dev` (this commit), merged into `master`; push to GitHub pending (§5) · **Backend:** `C:\Users\ghmi\personal\BingoAPI`, branch `migrate/net10` @ `67406d7`, also on its GitHub `master` through PR #71 (2026-11-18); backend Phase 8 is at Step 8.6 (half-done; the backend does not build) · **Backend sources:** `hopaut-migration-status.md` (steps), `TODO.md` → *Contract inventory* (the rows below), `docs/mobile-handoffs/` (no handoff `pending` on 2026-11-23)

The backend's new module endpoints exist, but the app still calls the legacy API: it expects PascalCase JSON inside `{ "Data": … }`, Unix-second times and errors chosen by status code. This document lists what the app must change to work with the new backend. None of it is implemented yet, and every row waits for its backend handoff. Mobile paths are relative to `lib/`.

## 1. How the sync works
- Each backend Phase 10 step finalises one module's HTTP contract and writes a handoff `C:\Users\ghmi\personal\BingoAPI\docs\mobile-handoffs\YYYY-MM-DD-phase10-<step>-<slug>.md` with Status `pending`. The steps: 10.1 foundation (problem details for every failure, plain IDs, ISO-8601 times), 10.2 Identity, 10.3 Users, 10.4 Posts and tags, 10.5 Attendance, 10.6 Announcements, 10.7 Ratings, 10.8 Moderation and bug reports. Push payloads come with backend step 9.4.
- A mobile session applies each pending handoff on `dev`, oldest first:
  - routes in `config/constants/api.dart`;
  - models in `data/models/`;
  - calls in `data/repositories/`;
  - error handling in `services/dio_service.dart`.
- Rules: no UI/UX change; reuse `LocaleKeys` and record missing translation keys as pending work. Then commit, add an activity row to `mobile-migration-status.md` and report the commit hash, so the backend marks the handoff `applied <date> <commit>`.
- Until a handoff exists, do not change API code for backend reasons: the module endpoints still change in Phase 10 (backend decision D-007). Breaking `/api/v1` changes are allowed because the backend and the mobile `dev` ship together (D-API-1); the released store build `v1.2.17` is not kept working.
- **Risk:** the backend's GitHub `master` (PR #71) no longer contains the legacy API (backend Step 6.1). If `https://hopout.eu` is deployed from it, the released app `v1.2.17` stops working until the tasks below ship.

## 2. Mobile prerequisites
Mobile Phase 0 is blocked at Step 0.3-H: `fvm flutter pub get` fails until the licensed HERE Explore Flutter plugin is placed at `plugins/here_sdk`, so the app can be neither analysed nor tested. The tasks below become implementable after Phase 0 and the Phase 1 foundations: `Result`/`AppFailure` (1.3), `DioClient` with interceptors (1.4), `AuthSession` (1.5), `freezed` DTOs (1.7). See `mobile-migration-status.md` and `mobile-playbook.md`.

## 3. Cross-cutting tasks

| ID | Task | Mobile files | Backend trigger | Mobile step |
|----|------|--------------|-----------------|-------------|
| S-01 | Errors: read RFC 9457 `application/problem+json` (`errorCode`, `errors` keyed by camelCase field paths, `traceId`) and choose messages by error code instead of status code. The module endpoints already answer problem details on their new failure paths; every failure does from 10.1 | `services/dio_service.dart`, `config/dio_base_options.dart` | 10.1 | 1.3, 1.4 |
| S-02 | JSON: camelCase keys and no `{ "Data": … }` envelope; lists are `{ "items", "nextCursor" }` | `data/models/*.dart`, `data/repositories/*.dart` | each module handoff | 1.7, 4.2 |
| S-03 | Times: ISO-8601 UTC strings instead of Unix seconds (the new module endpoints already send them) | models; remove `date_time_from_seconds.dart` | 10.1 and module handoffs | 4.9 |
| S-04 | IDs: request bodies carry typed IDs as `{ "value": n }` until 10.1 switches to plain values; send plain values only after the 10.1 handoff | repositories | 10.1 | – |
| S-05 | Cursor paging: `cursor` + `limit` (default 20, maximum 100), `nextCursor` is null on the last page; replaces page numbers and "204 when empty" | repositories, list providers | live in the 8.2–8.5 lists; feed in 10.4 | 4.5 |
| S-06 | Auth: a bearer token on every module endpoint (401 without one); refresh, then replay the queued requests; the JWT gains `sub` (= user id) next to `id`; `identity.*` error codes replace `FailReason` | `services/dio_service.dart`, `services/authentication_service.dart`, `data/models/identity.dart` | 10.2 | 1.4, 1.5, Phase 2 |
| S-07 | Concurrency: every module command can answer 409 `general.concurrency_conflict` → reload, then retry or tell the user | error mapping | live since 8.2 | 1.3 |
| S-08 | Rate limits: 429 with `Retry-After` (today the app only shows the quota message) | `services/dio_service.dart` | 10.x | 1.4 |
| S-09 | Pictures: uploads go through the Media pipeline (multipart; a picture moves from `Pending` to `Ready`) | event and user repositories | 9.5, 10.3, 10.4 | 4.3, 4.4 |
| S-10 | Push: OneSignal `data` keys for "attendance requested" (host), "attendance accepted" (attendee), "announcement created" and "post deleted" (attendees) | `services/notifications_service.dart` | 9.4 | 3.3 |

## 4. Module tasks
"Backend now" is the module endpoint on `migrate/net10` @ `67406d7`; "Target" is the Phase 10 route. Each target becomes final only with its handoff.

### Identity (backend 10.2; mobile Phase 2)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `LOGIN` (`data/repositories/authentication_repository.dart:18-54`) | `POST /api/v1/identity/login` → 200/400 `AuthResult` | same → 200 token pair; 401/403 problem + `identity.*` code | parse the token pair; map `identity.credentials.invalid`, `identity.email.not_confirmed`, `identity.user.locked_out` instead of `FailReason` |
| `REGISTER` (`:58-81`) | `POST /api/v1/identity/register` → 200/400 | → 201; 409 `identity.user.email_taken` | 201 = registered; 409 = already registered |
| `FB_AUTH` (`:83-106`) | missing | `POST /api/v1/identity/login/facebook` | new route |
| `REFRESH` (`:108-122`; `services/dio_service.dart:31-53`) | `POST /api/v1/identity/refresh` | same | token-pair model; replay the failed request |
| `FORGOT_PASSWORD` (`:125-138`) | `POST /api/v1/identity/forgot-password` | same | route `/identity/forgotpassword` → `/identity/forgot-password` |
| `CHANGE_PASSWORD` (`:140-160`) | `POST /api/v1/identity/change-password` | `{ currentPassword, newPassword }`; the caller comes from the token | new route and body (no e-mail) |
| `ADD_PASSWORD` (constant only) | missing | `POST /api/v1/identity/add-password` | route constant |
| JWT claims (`data/models/identity.dart:22-39`; `services/authentication_service.dart:45-58`) | `jti`, `email`, `id`, `role`; no `sub` | adds `sub` (= user id), keeps `id` | read the user id from `id` (or `sub`) |

### Users (backend 10.3; mobile 3.1)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `UserRepository.get` (`data/repositories/user_repository.dart:20-55`) | `GET /api/v1/users/{userId}` | `GET /api/v1/users/me`, `GET /api/v1/users/{userId}` | `me` for the caller; `registeredAt` (ISO) replaces `RegistrationTimeStamp` (backend 8.8) |
| `UserRepository.update` (`:20-55`) | `PUT /api/v1/users/{userId}/profile` `{ firstName, lastName, description }` (owner or admin) | `PUT /api/v1/users/me` | camelCase body; where the phone number lives is decided in backend 8.8 |
| `UserRepository.delete` (`:44-55`) | missing | `DELETE /api/v1/users/me` → 204 | new route |
| `deletePicture` (`:57-67`) | missing | `DELETE /api/v1/users/me/profile-picture` → 204 | new route |
| `uploadPicture` (`:69-101`) | `PUT /api/v1/users/{userId}/profile-picture` JSON `{ pictureUrl }` | `PUT /api/v1/users/me/profile-picture` multipart → 200 user | multipart field per the handoff |
| `ProfileRepository.get` (`data/repositories/profile_repository.dart:9-21`) | missing | `GET /api/v1/users/{userId}` | use the user read |

### Posts and tags (backend 10.4; mobile 4.1–4.5)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `EventRepository.get` (`data/repositories/event_repository.dart:17-29`) | `GET /api/v1/posts/{postId}` (anonymous) | same | post model: camelCase, ISO times, `tags`; entrance fee shape decided in 10.4; `isAttending` arrives in the post |
| `create` (`:31-59`; `data/models/post.dart:95-135`) | `POST /api/v1/posts` JSON; the caller is the host | multipart → 201 + `Location` | one 400 problem with `errors` per field (`event.title`, `event.description`, `event.slots`, `location`, `endTime`, `event.entrancePrice`, `tagNames`); 422 `posts.post.end_required` / `too_short` (< 15 min) / `too_long` (≥ 12 h) / `starts_in_the_past` (> 30 min) |
| `update` (`:62-92`) | `PATCH /api/v1/posts/{postId}` JSON partial → 204 | same; pictures through Media (9.5) | PATCH instead of multipart POST; null keeps a value; 422 `moved_to_the_past` / `already_started` / `ends_too_soon` / `slots_below_attendees`; 403 `posts.post.not_host` |
| `delete` (`:94-119`) | `DELETE /api/v1/posts/{postId}` → 204 / 404 (host or admin) | same + problem details | error codes |
| `search` (`:121-133`; `data/models/search_query.dart:29-51`) | `GET /api/v1/posts/nearby?longitude&latitude&radius&limit` (plain list; 1–15 km; ended posts excluded; no type, today or tag filter yet) | `GET /api/v1/posts?latitude=&longitude=&radiusMeters=&cursor=&limit=` + the legacy filters → `{ items, nextCursor }` | new query parameters and paging |
| `getEventMiniPosts(MY_ACTIVE / MY_INACTIVE)` (`:159-171`) | `GET /api/v1/users/me/posts?status=active\|inactive&cursor=&limit=` | same | new route and paging; inactive = disabled or ended |
| `TagRepository.get` (`data/repositories/tag_repository.dart:7-20`) | missing | `GET /api/v1/tags?search=&limit=` | new route; tags are lower-case, 1–20 characters, at most 20 per post |

### Attendance (backend 10.5; mobile 4.6)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `changeAttendanceStatus(ATTEND)` (`event_repository.dart:135-144`) | `POST /api/v1/attendance/{postId}/request` (caller from the token) | `PUT /api/v1/posts/{postId}/attendees/me` | open events accept at once, house parties wait for the host; 422 `attendance.participation.own_post` / `post_disabled` / `post_ended` / `no_slots_left`; 409 when already requested; rejected or cancelled users may ask again |
| `changeAttendanceStatus(UNATTEND)` (`:135-144`) | `POST /api/v1/attendance/{postId}/cancel` | `DELETE /api/v1/posts/{postId}/attendees/me` → 204 | new route |
| `getAttendees` (`:146-157`) | `GET /api/v1/posts/{postId}/attendees?status=accepted&limit=3` → `{ items: [{ userId, status, requestedAt, respondedAt }], nextCursor }` | same; names, pictures and the total (`AttendeesNumber`) follow in backend 8.8 / 10.5 | page model |
| `acceptAttendee` / `rejectAttendee` (`data/repositories/participant_repository.dart:9-31`) | `POST /api/v1/attendance/{postId}/accept/{userId}`, `…/reject/{userId}` (host only) | `PATCH /api/v1/posts/{postId}/attendees/{userId}` `{ status }` | 422 `no_slots_left` on accept; reject also removes an accepted attendee |
| `fetchAccepted` / `fetchPending` (`:33-59`) | `GET /api/v1/posts/{postId}/attendees?status=accepted\|pending&cursor=&limit=` (pending: host only, else 403 `attendance.participation.not_post_host`) | same | page model |
| `Post.IsAttending` (`data/models/post.dart`) | `GET /api/v1/attendance/{postId}/check` | `isAttending` in the post | read the post field |
| `getEventMiniPosts(ATTENDING_ACTIVE / ATTENDED_INACTIVE)` (`event_repository.dart:159-171`) | `GET /api/v1/users/me/attendances?status=active\|inactive&cursor=&limit=` | same | new route and paging |

### Announcements (backend 10.6; mobile 4.8)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `create` (`data/repositories/announcement_repository.dart:20-51`) | `POST /api/v1/announcements` `{ postId: { value }, message }` (host or admin; message 1–500 characters) | `POST /api/v1/posts/{postId}/announcements` `{ message }` → 201 | 400 `errors.message`; 403 `announcements.announcement.not_post_host` |
| `update` (`:20-51`) | `PUT /api/v1/announcements/{announcementId}` `{ message }` → 200 with the announcement | same | read the returned body |
| `get` (`:53-78`) | `GET /api/v1/announcements/{announcementId}` → `{ id, postId, message, createdAt, editedAt }` (host, accepted attendees, admins; others 403 `not_post_audience`) | same | new fields, ISO times |
| `delete` (`:53-78`) | `DELETE /api/v1/announcements/{announcementId}` (host or admin) | same + problem details | 409 on a concurrent edit |
| `getAll` (`:80-96`) | `GET /api/v1/posts/{postId}/announcements?cursor=&limit=` (newest first) | same | reverse each page for the chat view; paging |
| `getInbox` / `getOutbox` (`:98-124`) | `GET /api/v1/users/me/announcement-threads?box=inbox\|outbox&cursor=&limit=` → `{ items: [{ postId, lastAnnouncement }], nextCursor }` | same; the post's title, type and thumbnail follow in 10.6 | new list model |

### Ratings (backend 10.7; mobile 4.7)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `RatingRepository.get` (`data/repositories/rating_repository.dart:12-24`; today **POST** `/ratings/{ratingId}`) | `GET /api/v1/ratings/{ratingId}` → `{ id, rate, raterId, postId, feedback, createdAt }` | same | GET instead of POST |
| `getByUser` (`:26-39`) | `GET /api/v1/ratings/user/{userId}` | `GET /api/v1/users/{userId}/ratings` (paged) | new route and paging |
| `create` (`:41-58`) | `POST /api/v1/ratings` `{ rate, postId: { value }, feedback }`; the rater is the caller, the rated user the post's host; accepted attendees only | → 201; 409 duplicate | "already rated" is 409 `ratings.rating.already_rated` (the app shows it on 403 today); 403 `ratings.rating.not_attendee`; 422 `self_rating`; 400 `errors.rate` / `errors.feedback` (feedback ≤ 300 characters) |

### Moderation and bug reports (backend 10.8; mobile 5.1, 5.2)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| `ReportRepository.postReport` (`data/repositories/report_repository.dart:17-42`) | none at `67406d7` (backend Step 8.6 rewrites the module: reporter from the token, a second open report → 409, reason codes 1–6) | `POST /api/v1/posts/{postId}/reports` → 201; 409 duplicate | "already reported" is 409 (403 today) |
| `USER_REPORT` (`:44-46`; constant only) | none at `67406d7` (as above) | `POST /api/v1/users/{userId}/reports` | implement when the UI uses it |
| `bugReportPostAsync` (`:48-86`) | `POST /api/v1/bugs` JSON with screenshot URLs | `POST /api/v1/bug-reports` multipart → 201 | multipart per the handoff |

### Push notifications (backend 9.4; mobile 3.3)

| Mobile call | Backend now | Target | App change |
|-------------|-------------|--------|------------|
| OneSignal `setExternalUserId(userId)` (`services/notifications_service.dart:53-80`) | nothing sends pushes | pushes by external user id; the 9.4 handoff documents the `data` keys | parse the payload and open the matching screen |

The complete list of backend behaviour changes (status and error codes per endpoint) is in `C:\Users\ghmi\personal\BingoAPI\TODO.md` → *Contract inventory* → "Module-endpoint behaviour already changed before its Phase 10 sync".

## 5. Repository state

| Ref | Commit | Notes |
|-----|--------|-------|
| `dev` | this commit | working branch |
| `master` | the merge of this commit (earlier merges of 2026-11-23: `747d150`, `9981c39`, `89f5192`) | was `45cb515` (`v1.2.17`); changes only with explicit approval (Step 6.7 cuts `v2.0.0`) |
| `pre-flutter-3.24-baseline` (tag) | `75553a4` | baseline of Step 0.1 |

- **Push pending** → unblock action: the push of `dev`, `master` and the tag (requested on 2026-11-23) failed with HTTP 403. This machine's GitHub HTTPS credential is the account `mironicaG`, which has no write access to `GikuMironica/BingoMobile`, and its SSH key is a deploy key for `GikuMironica/BingoAPI` only. Give `mironicaG` write access (or sign in to Git Credential Manager with an account that has it), then run `git -C C:\Users\ghmi\personal\BingoMobile push origin dev master pre-flutter-3.24-baseline`.
- **Tracked credential files** (since 2022-11-19, also on GitHub): `android/app/upload-keystore.jks`, `ios/Runner/GoogleService-Info.plist`, `android/app/google-services.json` → user decision: remove them from the repository (from history too if it is public) and reset the Play upload key.

## 6. Prompt – next mobile session

```text
Agent: HopautMigration (workspace C:\Users\ghmi\personal\BingoMobile, branch dev).
Read HANDOVER.md (frontend tasks to stay in sync with the backend), mobile-migration-status.md and mobile-playbook.md.
1. Check C:\Users\ghmi\personal\BingoAPI\docs\mobile-handoffs\ for files with Status `pending`. Apply each, oldest first, as HANDOVER.md §1 describes (no UI/UX change), commit on dev, add an activity row to mobile-migration-status.md and report the commit hash per handoff.
2. If none is pending, do not change API code for backend reasons. Continue the mobile plan: Phase 0 is blocked at Step 0.3-H until the user places a Flutter 3.24.5-compatible HERE Explore plugin at plugins/here_sdk; ask for it if it is missing. The cross-cutting tasks S-01 to S-10 belong to the plan steps named in HANDOVER.md §3.
Commit locally on dev only; master changes only with explicit approval; push only when the user asks.
```
