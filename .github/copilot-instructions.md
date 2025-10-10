<!-- Copilot instructions for 'projek_mobile' Flutter app -->
# Copilot instructions — projek_mobile

This file contains targeted, actionable guidance for AI coding agents working on this Flutter project.

Keep edits concise. When in doubt, run or test small changes locally before proposing large refactors.

- Project root: `lib/`, `android/`, `ios/`, `pubspec.yaml`.
- App entry: `lib/main.dart` — app uses `MultiProvider` and an `ExploreRepository` seeded from `lib/data/explore_data.dart`.
- Primary state management: `provider` (see `lib/providers/*`). Create/modify providers under `lib/providers` and register them in `main.dart`.

Architecture notes (big picture):
- UI layer: `lib/screens/*` and `lib/widgets/*`.
- Data layer: `lib/data/*` contains repositories and DB helpers. `DbHelper` is a lightweight sqflite helper for course data (`lib/data/db_helper.dart`). `DatabaseService` in `lib/database/database_service.dart` manages app-wide tables (users, cart, courses, notifications).
- Models: `lib/models/*` (e.g., `explore_model.dart`) contain simple POJOs with toMap/fromMap used by DB helpers.

Important patterns and conventions:
- Two separate DBs used: `DbHelper` (explore_courses.db) for seeded content and `DatabaseService` (app_database.db) for user-related tables. Pay attention to which repository/service a change should use.
- Database helpers expose static methods to create tables and run queries (see `lib/database/database_course.dart`). Use those helpers inside transactions in `DatabaseService._onCreate`.
- Seed data: `main.dart` calls `ExploreRepository.seedIfEmpty(trendingCourses)` — preserve idempotence when inserting.
- Providers call repository methods, update local lists, set `isLoading`, and call `notifyListeners()` (see `ExploreProvider`). Follow that pattern for new providers.

Build / run / test workflows:
- Standard Flutter commands apply. From project root:
  - `flutter pub get` to fetch deps
  - `flutter run -d <device>` to run
  - `flutter build apk` / `flutter build ios` to build
- This repo uses `shared_preferences` and `sqflite` — emulator/device must support these plugins.

Common files to inspect for changes:
- DB schema and helpers: `lib/data/db_helper.dart`, `lib/database/*.dart`.
- Repositories: `lib/data/explore_repository.dart`.
- Providers/DI: `lib/providers/*` and `lib/main.dart`.
- App routing / auth gate: `lib/data/auth_gate.dart` (controls onboarding vs main page).

Examples (follow these when editing code):
- Add seeded data: use `ExploreRepository.seedIfEmpty(...)` rather than writing raw insert loops.
- Add a new provider: create file in `lib/providers/`, expose ChangeNotifier, register in `main.dart` inside `MultiProvider`.
- Add DB table: create `lib/database/database_xxx.dart` with static createTable/insert/query methods, then call it from `DatabaseService._onCreate`.

Edge-cases and gotchas:
- There are two DB files and versions. Don't mix table names between `explore_courses.db` and `app_database.db`.
- `main.dart` seeds the Explore DB on startup — editing the seed should not duplicate rows (helpers check and/or replace by idx).
- `AuthGate` uses `SharedPreferences` boolean `is_logged_in` — tests that require logged-in flows should set this pref or mock it.

If you change public APIs or add migrations:
- Update `_dbVersion` in the corresponding helper and implement `onUpgrade` logic. Preserve existing data where possible.

Files referenced in these instructions:
- `lib/main.dart`, `lib/data/db_helper.dart`, `lib/database/database_service.dart`, `lib/database/database_course.dart`, `lib/data/explore_repository.dart`, `lib/providers/explore_provider.dart`, `lib/models/explore_model.dart`, `lib/data/auth_gate.dart`.

If anything here is unclear or you want more detail (tests to run, recommended unit test examples, or CI steps), ask and I'll expand.
