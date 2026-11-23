# Handover – Hopaut mobile migration (BingoMobile)

**Written:** 2026-11-23 by HopautArchitect, synced with the backend handover `C:\Users\ghmi\personal\BingoAPI\HANDOVER.md` · **Mobile:** `dev` (the commit that last updated this file) merged into `master` with `--no-ff`; the push to `origin` requested on 2026-11-23 is pending: HTTP 403, see §6 (tree clean) · **Backend:** `migrate/net10` @ `67406d7` + handover commits; GitHub `master` holds `67406d7` since PR #71 (2026-11-18); Step 8.6 is half-done and the backend solution does not build

## 1. State
- Mobile Phase 0 is externally blocked at Step 0.3-H: dependency resolution needs the licensed HERE Explore Flutter plugin at the git-ignored path `plugins/here_sdk`. Steps 0.0 and 0.1 are ✅, Step 0.2 is 🟡 (Dart SDK constraint widened to `>=3.5.0 <4.0.0` in `e4dfab7`; the analyzer-guided null-safety migration needs dependency resolution), everything else is ⬜. No mobile code changed since `b20be13` (2026-09-27).
- 2026-11-23: the user approved merging `dev` into `master` in its current, mid-migration state, and confirmed that no other branch holds migration work (the only 2026 commits are on `dev`). `master` (frozen at `v1.2.17`, `45cb515`, an ancestor of `dev`) received `dev` with `--no-ff` merges (`747d150`, then again for this file's update), so it now has the Flutter 2 line plus the started modernization. The user asked to push `dev`, `master` and the tag `pre-flutter-3.24-baseline` to `origin`; the attempt failed with HTTP 403 (§6), so `origin/master` is still `45cb515` and `origin/dev` `55ac5b0`. `master` is not releasable: `fvm flutter pub get` fails until the HERE plugin is provided.
- Backend (for sync, details in the backend handover): Steps 8.3 Attendance, 8.4 Ratings and 8.5 Announcements are ✅; Step 8.6 Moderation is half-done in `67406d7` and the backend solution does not build. The user merged `migrate/net10` at `67406d7` into the backend's GitHub `master` through PR #71 (`bf1c818`, 2026-11-18), so that `master` does not build either. No backend change has reached the mobile contract yet (backend decision D-007).

## 2. Resume point
- **Next step:** 0.3-H – provision the HERE SDK plugin (`mobile-migration-status.md` Phase 0; `mobile-playbook.md` Phase 0), then 0.2 and the 0.3 dependency batches A–K.
- **Next action:** the user places a Flutter 3.24.5-compatible official HERE Explore Flutter plugin at `plugins/here_sdk` (licensed download, owner credentials). Then run `fvm flutter pub get`, verify decision D7, mark 0.3-H ✅ and resume 0.2 (null-safety migration guided by `fvm flutter analyze`).
- **Half-done:** None.

## 3. Validation status

| Command | Result | Date |
|---------|--------|------|
| `fvm flutter --version` | Flutter 3.24.5 / Dart 3.5.4 (FVM 4.3.1) | 2026-09-27 |
| `fvm flutter pub get` | fails: the path dependency `plugins/here_sdk` is absent (evidence in `e4dfab7`) | 2026-09-27 |
| `fvm flutter analyze`, `fvm flutter test` | not runnable while dependency resolution fails | 2026-09-27 |
| `git status` (`dev`) | clean | 2026-11-23 |

`flutter build` and `flutter run` are not run without the user's separate authorization (agent rule).

## 4. Branches and tags

| Ref | Commit | Notes |
|-----|--------|-------|
| `dev` | the commit that last updated this file | working branch; push pending (§6) |
| `master` | merge commits of 2026-11-23 (`747d150`, `9981c39` and the one carrying this update) | push pending (§6); was `45cb515` (`v1.2.17`); changes again only with explicit approval (Step 6.7 cuts `v2.0.0`) |
| `pre-flutter-3.24-baseline` (tag) | `75553a4` | baseline of Step 0.1; push pending (§6) |
| other `origin/*` branches | 2021–2022 | untouched |

## 5. Contract changes (backend ↔ mobile)
None pending: `C:\Users\ghmi\personal\BingoAPI\docs\mobile-handoffs\` holds only `_TEMPLATE.md` and `README.md`. The backend's module endpoints stay unsynced until backend Phase 10, which writes one handoff per module with an `applied <date> <commit>` status. The behaviour those handoffs will describe (backend steps 6.9, 7.7 and 8.1–8.5 so far) is listed in the backend `TODO.md` → *Contract inventory* → "Module-endpoint behaviour already changed before its Phase 10 sync". Until a handoff with Status `pending` exists, do not change routes, models, repositories or error handling for backend reasons.

| Endpoint | Change | Breaking? | Handoff file | Mobile status |
|----------|--------|-----------|--------------|---------------|
| None | – | – | – | – |

## 6. Open decisions and blockers
- **0.3-H HERE SDK plugin** → unblock action: the user downloads the licensed HERE Explore Flutter plugin that matches Flutter 3.24.5 and places it at `plugins/here_sdk` (git-ignored; never commit the archive or credentials).
- **Decisions D1–D5 and D7** are not locked yet (`mobile-migration-status.md` → Decisions).
- **`master`:** merged mid-migration on 2026-11-23 at the user's request; agents keep working on `dev` only, and `master` changes again only with explicit approval.
- **Push pending** → unblock action: the push of `dev`, `master` and the tag (requested by the user on 2026-11-23) failed with HTTP 403. This machine's GitHub HTTPS credential is the account `mironicaG`, which has no write access to `GikuMironica/BingoMobile`, and its SSH key is a deploy key for `GikuMironica/BingoAPI` only. Give `mironicaG` write access to the repository (or sign in to Git Credential Manager with an account that has it), then run `git -C C:\Users\ghmi\personal\BingoMobile push origin dev master pre-flutter-3.24-baseline`. Agents push only when the user asks.
- **Tracked credential files** (since 2022-11-19, also on GitHub): `android/app/upload-keystore.jks` (`f32f2c3`), `ios/Runner/GoogleService-Info.plist` (`13a90bb`) and `android/app/google-services.json` → unblock action (user decision): remove them from the repository (from history too if the repository is public) and reset the Play upload key; keep the Firebase API keys restricted.
- **Backend:** its build is broken until Step 8.6 is finished (on its GitHub `master` too, since PR #71), and Release builds need the Six Labors license key (backend blocker B-002). Neither blocks mobile work.

## 7. Prompt – next mobile session

```text
Agent: HopautMigration (workspace C:\Users\ghmi\personal\BingoMobile, branch dev).
Resume from HANDOVER.md and mobile-migration-status.md. Phase 0 is blocked at Step 0.3-H until the user places a Flutter 3.24.5-compatible HERE Explore plugin at plugins/here_sdk; if it is there, run fvm flutter pub get, verify D7, flip 0.3-H and continue with 0.2 and the 0.3 batches. If it is not there, stop and ask for it.
There are no pending backend contract handoffs (C:\Users\ghmi\personal\BingoAPI\docs\mobile-handoffs\ has no file with Status `pending`); do not change routes, models, repositories or error handling for backend reasons, and do not change UI/UX.
Commit locally on dev only. master was merged from dev on 2026-11-23 at the user's request; its push is pending (HANDOVER.md §6). Do not change master again without explicit approval, and push only when the user asks.
```

## 8. Prompt – next backend session

```text
Agent: HopautArchitect (workspace C:\Users\ghmi\personal\BingoAPI, branch migrate/net10).
Resume from HANDOVER.md (backend). First make the build green by finishing Step 8.6 – Moderation, which is half-done in commit 67406d7; follow HANDOVER.md §2 and the prompt in its §7.
```
