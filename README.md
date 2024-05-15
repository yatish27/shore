<h1 align="center">
  <a href="#">
    <img src="https://github.com/yatish27/shore/assets/1014383/fbad8ed2-9510-4693-a342-4bafa515b164" width="128px"/>
  </a>

  Shore

  <p align="center">
    <a href="https://github.com/yatish27/shore/actions">
      <img alt="Build Status" src="https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg"/>
    </a>
    <a href="https://github.com/yatish27/shore/blob/master/LICENSE.txt">
      <img alt="License" src="https://img.shields.io/badge/license-MIT-428F7E.svg"/>
    </a>
    <a href="https://codeclimate.com/github/yatish27/shore/maintainability"><img src="https://api.codeclimate.com/v1/badges/1cd4e3f1c0a4c5af29b1/maintainability" /></a>
  </p>
</h1>

## Introduction


## Features ⚡️

- **Ruby**: Ruby 3.3.1 
- **Rails**: [Rails 7.1](https://rubyonrails.org)
- **PostgreSQL**: [PostgresSQL 16.3](https://www.postgresql.org)
- **Tailwind CSS**: Uses [Tailwind CSS](https://tailwindcss.com) for styling.
- **Vite Ruby**: Uses [Vite Ruby](https://vite-ruby.netlify.app) for asset management. It is based on [Vite.js](https://vitejs.dev). It replaces webpacker, jsbundling-rails, cssbundling-rails, importmaps and sprockets.
- **Phlex**: Uses [Phlex](https://www.phlex.fun) for component-based views. It is an alternative to [ViewComponent](https://viewcomponent.org).
- **Solid Queue**: Uses [Solid Queue](https://github.com/rails/solid_queue) for background processing.
- **Minitest/FactoryBot**: Uses Rails' default testing library, minitest along with [Factorybot](https://github.com/thoughtbot/factory_bot).
- **Rubocop**: Auto-formats Ruby code with [rubocop](https://rubocop.org).
- **Prettier**: Auto-formats JavaScript and CSS code with [prettier](https://prettier.io).
- **Github Actions**: Uses Github Actions for continuous integration and deployment.
- **Deployment**: Supports deployment at [Heroku](https://www.heroku.com/platform) and [Render](https://render.com)


## Getting Started 🚀


### System Requirements
You will need the following to run the application.

- **Ruby 3.3.1**
  <details>
    <summary>How to install Ruby</summary>
    
    Use a Ruby version manager like [rbenv](https://github.com/rbenv/rbenv?tab=readme-ov-file#using-package-managers) to install ruby.
    
    1. Install rbenv
    ```bash
    brew install rbenv ruby-build
    ```

    2. Install ruby with the version in [.ruby-version](./../.ruby-version)

    ```
    rbenv install 3.3.1
    ```

    3. Check the version 
    ```
    ruby -v
    ```
    ```
    ruby 3.3.1 (2024-04-23 revision c56cd86388) [arm64-darwin23]
    ```
  </details>

- **PostgreSQL 16.3**
  <details>
    <summary>How to install PostgresSQL</summary>
    
    You can install PostgresSQL using [postgresapp.com](https://postgresapp.com) or Homebrew

    ### Using Homebrew

    1. Install 

      ```
      brew install postgresql@16
      ```

    2. Add psql to $PATH

      ```
      echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.bashrc
      ```
    3. Start the server
    ```
    brew services start postgresql@16

    ```
    4. Create a `postgres` user

    ```
    createuser -s postgres
    ```

    5. Set the password for postgres

    ```
    psql postgres
    ```
    Within psql  

    ```
    ALTER ROLE postgres WITH PASSWORD 'password';
    ```

    ### Using postgresapp.com

    1. Visit https://postgresapp.com and download the app with PostgresSQL
    2. Install the app
    3. Start the server and initialize the cluster using the UI

  </details>

- **Node 22**
  <details>
    <summary>How to install Node</summary>
    
    ```
    brew install node
    ```
    ```
    node -v
    ```
  </details>

- **Yarn 1.22**
  <details>
    <summary>How to install Yarn</summary>
    
    ```
    brew install yarn
    ```
    ```
    yarn -v
    ```
  </details>


Refer [installing prerequisites](./docs/installing_prerequisites.md) to install these dependencies

### Initial setup
- Shore is preconfigured base Ruby on Rails application. You can clone this repository and add it to your repo.
  ```bash
  git clone git@github.com:yatish27/shore.git your_new_project_name
  cd your_new_project_name
  ```

- The default name of the application is Shore. You can rename the application to you desired new name.
The name should be in camelcase.

  ```bash
  ./bin/replace_name YourNewProjectName
  ```

- Copy the `env.sample` to `.env`

- The default username and password for database is set to `postgres` and `password`. You can override them in `.env` file.


- Run `bin/setup` to setup the application. It prepares the database, install the required ruby gems and javascript packages. The script is idempotent, so you can run it multiple times.

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
Shore has support for docker and docker compose.
Install Docker and docker desktop


Once you have cloned the repository and have docker installed

- Run `docker compose build` to build. It will build the images.
- Run `docker compose run --rm web bin/setup` to create and setup the database.
- Run `docker compose up` to start the application. 
Since the local code from your host machine is mounted in the docker container, any change made in the code will be directly reflected. You don't need to rebuild you container.

## Deployment
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
