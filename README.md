<p align="center">
  <img src="docs/logo.png" width="128" />
</p>

<h1 align="center">Shore</h1>

<p align="center">
  <a href="https://github.com/yatish27/shore/actions/workflows/ci.yml"><img src="https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg" alt="Build Status" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-428F7E.svg" alt="License" /></a>
</p>

Shore is a Ruby on Rails template with a modern stack to start your next project.

## Features

- **Ruby** — [Ruby 4.0.1](https://www.ruby-lang.org)
- **Rails** — [Rails 8.1](https://rubyonrails.org)
- **PostgreSQL** — [PostgreSQL 18](https://www.postgresql.org)
- **React + Inertia.js** — [Inertia Rails](https://inertia-rails.dev)
- **Tailwind CSS** — [Tailwind CSS v4](https://tailwindcss.com)
- **Bun** — [Bun](https://bun.sh) for js package management and asset bundling
- **Solid Queue** — [Solid Queue](https://github.com/rails/solid_queue) for background jobs
- **Solid Cache** — [Solid Cache](https://github.com/rails/solid_cache) for caching
- **Solid Cable** — [Solid Cable](https://github.com/rails/solid_cable) for WebSockets
- **RuboCop** — [RuboCop](https://rubocop.org) with Standardrb config
- **GitHub Actions** — CI/CD with security scanning, linting, and tests

## Getting Started

### Prerequisites

See the full [Prerequisites guide](docs/prerequisites.md) for detailed installation steps.

- [Ruby 4.0.1](https://www.ruby-lang.org)
- [PostgreSQL 18](https://www.postgresql.org)
- [Bun](https://bun.sh)

### Setup

```bash
brew bundle
bin/setup
```

### Running the application

```bash
bin/dev
```

Visit [http://localhost:3000](http://localhost:3000)

## Testing

```bash
bin/rails test
bin/rails test:system
```

## License

Shore is released under the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

PRs are welcome.
