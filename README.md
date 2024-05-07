![shore_logo_128](https://github.com/yatish27/shore/assets/1014383/fbad8ed2-9510-4693-a342-4bafa515b164)

# Shore

A cutting-edge and opinionated Ruby on Rails template equipped with pragmatic defaults to kickstart your next project 🚀



![example workflow](https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg)

This template serves as a robust foundation, providing all the necessary setups and defaults required for launching a new Ruby on Rails application swiftly.


## Features 🌟
- **Ruby & Rails**: Ruby 3.3.1 with Rails 7.1.2
- **Styling**: TailwindCSS
- **Asset managment**: [ViteRuby](https://github.com/ElMassimo/vite_ruby)
- **Front-end Libraries**: Hotwire, Turbo & StimulusJS 
- **Views**: [Phlex](https://www.phlex.fun)
- **Package Management**: [Bun](https://bun.sh). It replaces Node and Yarn.
- **Testing Suite**:
  - Minitest for unit and functional integration tests
  - FactoryBot for setting up test data
  - cypress-rails for end-to-end system tests
- **Background Processing**: SolidQueue 
- **Linting and formatting**: Rubocop
- **Containerization**:
  - Docker support with separate Dockerfiles and docker-compose.yml for development, test, and production environments
- **Continuous Integration**: Automated workflows with GitHub Actions
- **Deployment Options**:
  - Heroku
  - Render
  - Hatchbox.io
  - DigitalOcean with Kamal

## Prerequisites

This project requires:

- Ruby (see [.ruby-version](./.ruby-version)), preferably managed using [rbenv](https://github.com/rbenv/rbenv)
- Node 18 (LTS) or newer
- Yarn 1.x (classic)
- PostgreSQL must be installed and accepting connections

On macOS, these [Homebrew](http://brew.sh) packages are recommended:

```
brew install rbenv
brew install node
brew install yarn
brew install postgresql@16
```

## Getting started

### bin/setup

Run this script to install necessary dependencies and prepare the Rails app to be started for the first time.

```
bin/setup
```

> [!TIP]
> The `bin/setup` script is idempotent and is designed to be run often. You should run it every time you pull code that introduces new dependencies or makes other significant changes to the project.

### Run the app!

Start the Rails server with this command:

```
yarn start
```

The app will be located at <http://localhost:3000/>.

## Development

Use this command to run the full suite of automated tests and lint checks:

```
bin/rake
```

> [!TIP]
> Rake allows you to run all checks in parallel with the `-m` option. This is much faster, but since the output is interleaved, it may be harder to read.

```
bin/rake -m
```

### Fixing lint issues

Some lint issues can be auto-corrected. To fix them, run:

```
bin/rake fix
```

> [!WARNING]
> A small number of Rubocop's auto-corrections are considered "unsafe" and may
> occasionally produce incorrect results. After running `fix`, you should
> review the changes and make sure the code still works as intended.
