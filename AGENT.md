# AGENT.md

This file provides guidance to AI coding agents when working with code in this repository.

## About Shore

Shore is a web application built with Rails 8.1 and React 19 via Inertia.js.

## Development Commands

### Starting Development

```
bin/setup    # Install deps, prepare all databases
bin/dev      # Starts Rails server (port 3000), Bun JS watcher, Tailwind CSS watcher, Solid Queue
```

### Database Commands

- `bin/rails db:prepare` — Create and migrate all databases
- `bin/rails db:migrate` — Run migrations
- `bin/rails db:rollback` — Undo last migration
- `bin/rails db:seed` — Load seed data
- `bin/rails db:reset` — Drop, create, migrate, seed

### Testing & Code Quality

- `bin/rails test` — Run all unit/integration tests
- `bin/rails test:system` — Run system tests (Capybara + Selenium)
- `bin/rails test test/models/foo_test.rb` — Run a single test file
- `bin/rails test test/models/foo_test.rb:42` — Run a single test by line
- `bin/rubocop` — Run linter
- `bin/rubocop -a` — Auto-fix lint issues
- `bin/brakeman --no-pager` — Security analysis
- `bin/bundler-audit` — Scan for vulnerable gems

### Build Commands

- `bun run build` — Build JavaScript
- `bun run build:css` — Build CSS

## Architecture Overview

### Tech Stack

- Rails 8.1 with PostgreSQL (multi-database)
- Inertia.js 2 with React 19
- Bun (JS bundling via `bun.config.js`)
- Tailwind CSS 4
- Propshaft (asset pipeline)
- Solid Queue, Solid Cache, Solid Cable (no Redis)
- Minitest + Fixtures + Capybara (testing)

### Multi-Database Setup

The app uses four PostgreSQL databases configured in `config/database.yml`:

- `primary` — Application data
- `cache` — Solid Cache
- `queue` — Solid Queue
- `cable` — Solid Cable

All four are created/migrated together by `bin/rails db:prepare`. CI uses `POSTGRES_PASSWORD` env var for auth (not `DATABASE_URL`).

### Key Architectural Patterns

- **Inertia.js Pattern:** Controllers render Inertia responses (`render inertia: "PageName", props: { ... }`) instead of JSON APIs or ERB views.
- **Frontend Structure:** Pages in `app/javascript/pages/`, shared components in `app/javascript/components/`, utilities in `app/javascript/lib/`. Path alias `@/` maps to `app/javascript/`.
- **Page Registry:** New Inertia pages must be added to the `pages` map in `app/javascript/inertia.tsx`.
- **No Redis:** Background jobs, caching, and WebSockets all use PostgreSQL via the Solid gems.
- **Database Architecture**
  - PostgreSQL
  - UUID primary keys using pgcrypto extension
  - JSONB columns for flexible metadata storage
  - Encrypted fields for sensitive data (OAuth tokens)

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
- Do not add Redis — the app uses Solid gems backed by PostgreSQL

## Testing Philosophy

### Testing Commands

- `bin/rails test` - Run all tests
- `bin/rails test:db` - Run tests with database reset
- `bin/rails test:system` - Run system tests only (use sparingly - they take longer)
- `bin/rails test test/models/account_test.rb` - Run specific test file
- `bin/rails test test/models/account_test.rb:42` - Run specific test at line
- `bin/ci` - this runs all tests and other CI. This is the prerequisite to merging to `main`

### General Testing Rules

- **ALWAYS use Minitest + fixtures** (NEVER RSpec or factories)
- Keep fixtures minimal (2-3 per model for base cases)
- Create edge cases on-the-fly within test context
- Use Rails helpers for large fixture creation needs

### Test Quality Guidelines

- **Write minimal, effective tests** - system tests extremely sparingly, only for application critical flows
- **Only test critical and important code paths**
- **Test boundaries correctly:**
  - Commands: test they were called with correct params
  - Queries: test output
  - Don't test implementation details of other classes

### Testing Examples

```ruby
# GOOD - Testing critical domain business logic
test "good test example" do
  DomainModel.any_instance.expects(:some_operation).returns([]).once
  assert_difference "DomainModel.count", 2 do
    DomainModel.do_something
  end
end

# BAD - Testing ActiveRecord functionality
test "bad low value test" do
  record = DomainModel.new(attr1: "value1", attr2: "value2")
  assert record.save
end
```

### Stubs and Mocks

- Use `mocha` gem and VCR for external services (only in the providers layer)
- Prefer `OpenStruct` for mock instances
- Only mock what's necessary

## Code Maintenance

- Run `bundle exec rubocop -a` after significant code changes
- Security scanning with `bundle exec brakeman`

## Database Schema Notes

- All tables use UUID primary keys (pgcrypto extension)
- Timestamps use `timestamptz` for timezone awareness
- JSONB columns for flexible metadata storage
- Comprehensive indexing strategy for performance
- Encrypted fields for sensitive data (OAuth tokens, API keys)

## Look up documentation with Context7

When code examples, setup or configuration steps, or library/API documentation are requested, use the Context7 mcp server to get the information.

## Analysis Process:

- Compare new code with existing rules
- Identify patterns that should be standardized
- Look for references to external documentation
- Check for consistent error handling patterns
- Monitor test patterns and coverage

## Code Guidelines

- Always use Tailwind classes instead of inline styles
- Before git committing and pushing any code, run rubocop with autofix
- Always use minitest
- All React components and views should be TSX
- Ask lots of clarifying questions when planning. The more the better. Make extensive use of AskUserQuestionTool to gather requirements and specifications. You can't ask too many questions.
- Use Playwright to regularly verify E2E functionality
- When something new is added that will need some type of setup, ensure it's added to @README.md

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs on PRs and pushes to main:

1. **scan_ruby** — Brakeman + bundler-audit
2. **lint** — RuboCop
3. **test** — `bin/rails db:test:prepare test`
4. **system-test** — Asset precompile + `bin/rails test:system`
