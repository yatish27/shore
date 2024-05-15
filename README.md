![shore_logo_128](https://github.com/yatish27/shore/assets/1014383/fbad8ed2-9510-4693-a342-4bafa515b164)

# Shore

![example workflow](https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg)

## Introduction


## Features ⚡️

- **Ruby**: Ruby 3.3.1 
- **Rails**: [Rails 7.1](https://rubyonrails.org)
- **PostgreSQL**: [PostgresSQL 16.3](https://www.postgresql.org)
- **Tailwind CSS**: Uses [Tailwind CSS](https://tailwindcss.com) for styling.
- **Vite Ruby**: Uses [Vite Ruby](https://vite-ruby.netlify.app) for asset management. It is based on [Vite.js](https://vitejs.dev). It replaces webpacker, jsbundling-rails, cssbundling-rails, importmaps and sprockets.
- **Bun**: Uses [Bun](https://bun.sh) for npm package manager. No need to install node and yarn.
- **Phlex**: Uses [Phlex](https://www.phlex.fun) for component-based views. It is an alternative to [ViewComponent](https://viewcomponent.org).
- **Solid Queue**: Uses [Solid Queue](https://github.com/rails/solid_queue) for background processing.
- **Minitest/FactoryBot**: Uses Rails' default testing library, minitest along with [Factorybot](https://github.com/thoughtbot/factory_bot).
- **Rubocop**: Auto-formats Ruby code with [rubocop](https://rubocop.org).
- **Prettier**: Auto-formats JavaScript and CSS code with [prettier](https://prettier.io).
- **Github Actions**: Uses Github Actions for continuous integration and deployment.
- **Deployment**: Supports deployment at [Heroku](https://www.heroku.com/platform) and [Render](https://render.com)


## Getting Started 💻

### Prerequisites
- Ruby 3.3.1
  - Check the [.ruby-version](.ruby-version)
- PostgreSQL 16.3
- Bun 1.1.8
- [Overmind](https://github.com/DarthSim/overmind) (optional), it will be used in place of Foreman - `brew install tmux overmind`

Refer [installing prerequisites](./docs/installing_prerequisites.md) to install these dependencies

### Building a new application

1. Clone the base repository
```
git clone git@github.com:yatish27/shore.git your_new_project_name
```

2. Enter the project directory
```
cd your_new_project_name
```

3. Replace `Shore` with your application's name. The name should be camelCase. 


```
./bin/replace_name YourNewProjectName
```

4. Run setup

```
./bin/setup
```

5. Start your application
```
bin/dev
```

6. Visit `http://localhost:3000`


