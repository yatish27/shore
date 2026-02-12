# AGENT.md

This file provides guidance to AI coding agents when working with code in this repository.

## About Shore

Shore is a web application built with Rails 8.1 and React 19 via Inertia.js.

## Development Commands

**Starting Development:**
```
bin/setup    # Install deps, prepare all databases
bin/dev      # Starts Rails server (port 3000), Bun JS watcher, Tailwind CSS watcher, Solid Queue
```

**Database Commands:**
- `bin/rails db:prepare` — Create and migrate all databases
- `bin/rails db:migrate` — Run migrations
- `bin/rails db:rollback` — Undo last migration
- `bin/rails db:seed` — Load seed data
- `bin/rails db:reset` — Drop, create, migrate, seed

**Testing & Code Quality:**
- `bin/rails test` — Run all unit/integration tests
- `bin/rails test:system` — Run system tests (Capybara + Selenium)
- `bin/rails test test/models/foo_test.rb` — Run a single test file
- `bin/rails test test/models/foo_test.rb:42` — Run a single test by line
- `bin/rubocop` — Run linter
- `bin/rubocop -a` — Auto-fix lint issues
- `bin/brakeman --no-pager` — Security analysis
- `bin/bundler-audit` — Scan for vulnerable gems

**Build Commands:**
- `bun run build` — Build JavaScript
- `bun run build:css` — Build CSS

## Architecture Overview

**Tech Stack:**
- Rails 8.1 with PostgreSQL (multi-database)
- Inertia.js 2 with React 19
- Bun (JS bundling via `bun.config.js`)
- Tailwind CSS 4
- Propshaft (asset pipeline)
- Solid Queue, Solid Cache, Solid Cable (no Redis)
- Minitest + Capybara (testing)

**Multi-Database Setup:**
The app uses four PostgreSQL databases configured in `config/database.yml`:
- `primary` — Application data
- `cache` — Solid Cache
- `queue` — Solid Queue
- `cable` — Solid Cable

All four are created/migrated together by `bin/rails db:prepare`. CI uses `POSTGRES_PASSWORD` env var for auth (not `DATABASE_URL`).

**Key Architectural Patterns:**

1. **Inertia.js Pattern:** Controllers render Inertia responses (`render inertia: "PageName", props: { ... }`) instead of JSON APIs or ERB views.
2. **Frontend Structure:** Pages in `app/javascript/pages/`, shared components in `app/javascript/components/`, utilities in `app/javascript/lib/`. Path alias `@/` maps to `app/javascript/`.
3. **Page Registry:** New Inertia pages must be added to the `pages` map in `app/javascript/inertia.tsx`.
4. **No Redis:** Background jobs, caching, and WebSockets all use PostgreSQL via the Solid gems.

## Project Layout

```
app/
  controllers/           # Rails controllers (render Inertia pages)
  models/                # ActiveRecord models
  javascript/
    pages/               # Inertia page components (React TSX)
    components/          # Shared React components
    lib/                 # Frontend utilities
    inertia.tsx          # Inertia entrypoint — page registry
  views/                 # Rails layouts only (Inertia handles UI)
test/
  models/                # Model unit tests
  controllers/           # Controller tests
  system/                # System tests (Capybara + Selenium)
  integration/           # Integration tests
config/
  database.yml           # Multi-database config
```

## Code Guidelines

- ALWAYS use Minitest + fixtures (NEVER RSpec or factories)
- All React components should be TSX
- Use Tailwind CSS utility classes for styling
- Run `bin/rubocop` before committing Ruby changes
- Run `bin/rails test` to verify changes before finishing
- Follow Standard Ruby conventions (the project's configured ruleset)
- Do not add Docker, Kamal, or Redis — the app uses Solid gems backed by PostgreSQL

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs on PRs and pushes to main:

1. **scan_ruby** — Brakeman + bundler-audit
2. **lint** — RuboCop
3. **test** — `bin/rails db:test:prepare test`
4. **system-test** — Asset precompile + `bin/rails test:system`
