# Prerequisites (macOS)

## 1. Install Homebrew packages

```bash
brew bundle
```

This installs:
- **mise** - Version manager for Ruby
- **PostgreSQL 18** - Database
- **vips** - Image processing (used by ActiveStorage)
- **Bun** - JavaScript runtime and package manager
- **act** - Run GitHub Actions locally

## 2. Install Ruby via mise

```bash
mise use ruby@4.0.1
```

## 3. Start PostgreSQL and create the database user

```bash
brew services start postgresql@18
```

Create the `postgres` superuser with password `password` (matching `config/database.yml` defaults):

```bash
createuser -s -P postgres
```

When prompted, enter the password: `password`

## 4. Setup the app

```bash
bin/setup
```

This installs Ruby via mise, runs `bundle install`, `bun install`, and prepares the database.

## 5. Start the dev server

```bash
bin/dev
```

This runs the Vite dev server (port 3036), Rails server (port 3000), and Solid Queue job runner via `Procfile.dev`. Tailwind CSS is handled by the Vite plugin — no separate watcher needed.
