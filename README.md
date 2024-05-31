<h1 align="left">
  <a href="#">
    <img src="https://github.com/yatish27/shore/assets/1014383/fbad8ed2-9510-4693-a342-4bafa515b164" width="128px"/>
  </a>

  Shore

  <p align="left">
    <a href="https://github.com/yatish27/shore/actions">
      <img alt="Build Status" src="https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg"/>
    </a>
    <a href="https://github.com/yatish27/shore/blob/master/LICENSE.txt">
      <img alt="License" src="https://img.shields.io/badge/license-MIT-428F7E.svg"/>
    </a>
    <a href="https://codeclimate.com/github/yatish27/shore/maintainability"><img src="https://api.codeclimate.com/v1/badges/1cd4e3f1c0a4c5af29b1/maintainability" /></a>
  </p>
</h1>

## Introduction 📜

Shore is a Ruby on Rails template with modern stack to start your new project.

## Features ⚡️

- **Ruby**: Ruby 3.3.1 
- **Rails**: [Rails 7.1](https://rubyonrails.org)
- **PostgreSQL**: [PostgresSQL 16.3](https://www.postgresql.org)
- **Tailwind CSS**: Uses [Tailwind CSS](https://tailwindcss.com) for styling.
- **Vite Ruby**: Uses [Vite Ruby](https://vite-ruby.netlify.app) for asset management. It is based on [Vite.js](https://vitejs.dev). It replaces webpacker, jsbundling-rails, cssbundling-rails, importmaps and sprockets/propshaft.
- **Bun**: Uses [Bun](https://bun.sh/) as package manager. It replaces Node and Yarn.
- **Phlex**: Uses [Phlex](https://www.phlex.fun) for component-based views. It is an alternative to [ViewComponent](https://viewcomponent.org).
- **Solid Queue**: Uses [Solid Queue](https://github.com/rails/solid_queue) for background processing.
- **Minitest/FactoryBot**: Uses Rails' default testing library, minitest along with [Factorybot](https://github.com/thoughtbot/factory_bot).
- **Rubocop**: Auto-formats Ruby code with [rubocop](https://rubocop.org).
- **Prettier**: Auto-formats JavaScript and CSS code with [prettier](https://prettier.io).
- **Github Actions**: Uses Github Actions for continuous integration and deployment.
- **Deployment**: Supports deployment on [Heroku](https://www.heroku.com/platform) and [Render](https://render.com)


## Getting Started 🚀


### System Requirements
You will need the following to run the application.

- [**Ruby 3.3.1**](./docs/installing_prerequisites.md#ruby)
- [**PostgreSQL 16.3**](./docs/installing_prerequisites.md#postgresql)
- [**Bun**](./docs/installing_prerequisites.md#bun)

Refer [here](./docs/installing_prerequisites.md) to install these dependencies

### Initial setup
- Shore is a preconfigured base Ruby on Rails application. You can clone this repository and add it to your repo.
  ```bash
  git clone git@github.com:yatish27/shore.git your_new_project_name
  cd your_new_project_name
  ```

- The application's default name is Shore. You can rename it to your desired new name. The name should be in camelcase.

  ```bash
  ./bin/rename_project YourNewProjectName
  ```

- Copy the `env.sample` to `.env`

  - The default username and password for database is set to `postgres` and `password`. You can override them in `.env` file.

- Run `bin/setup` to set up the application. It prepares the database and installs the required ruby gems and javascript packages. The script is idempotent, so you can run it multiple times.

  ```bash
  ./bin/setup
  ```

### Running the application

Start your application

```bash
./bin/dev
```

This runs overmind or foreman using the Procfile.dev. It starts the rails server, solid queue background job process and vite server.

Visit `http://localhost:3000` to see the home page 🚀.

### Running locally with docker 
Shore supports docker and docker compose for local development.
Install Docker and Docker desktop,

Once you have cloned the repository and have Docker installed, follow the following steps

- Run `docker compose build` to build. It will build the necessary images.
- Run `docker-compose run --rm web bin/setup` to create and set up the database.
- Run `docker compose up` to start the application. 
Since the local code from your host machine is mounted in the docker container, any change made locally will be directly reflected. You don't need to rebuild the container.

## Deployment 📦
- Heroku
- Render

## Testing 🧪
Running all tests
```
./bin/rails test:all
```

Running a single test
```
./bin/rails test test/jobs/hello_world_job_test.rb
```

## License 🔑
Shore is released under the [MIT License](./LICENSE.txt).

## Contributing 🤝
PRs are welcome
