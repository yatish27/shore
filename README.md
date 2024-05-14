![shore_logo_128](https://github.com/yatish27/shore/assets/1014383/fbad8ed2-9510-4693-a342-4bafa515b164)

# Shore

![example workflow](https://github.com/yatish27/shore/actions/workflows/ci.yml/badge.svg)

## Introduction


## 🌟 Features

- 🔻 [Ruby (3.3.1) and Rails (7.1)](https://rubyonrails.org)
- 🐘 [PostgresSQL 16.3](https://www.postgresql.org)
- 💨 [Tailwind CSS](https://tailwindcss.com)
- 🛠 Uses [Vite Ruby](https://vite-ruby.netlify.app) for asset management. It is based on [Vite.js](https://vitejs.dev). It replaces webpacker, jsbundling-rails, cssbundling-rails, importmaps and sprockets.
- 🍞 Uses [Bun](https://bun.sh) for npm package manager. No need to install node and yarn.
- 🖼 Uses [Phlex](https://www.phlex.fun) for component-based views. It is an alternative to [ViewComponent](https://viewcomponent.org).
- 🔍 Uses Rails' default testing library, minitest along with [Factorybot](https://github.com/thoughtbot/factory_bot)
- 📏 Auto-formats Ruby code with [rubocop](https://rubocop.org).
- ✨ Auto-formats JavaScript and CSS code with [prettier](https://prettier.io).
- 🚀 Uses Github Actions for continuous integration and deployment.
- 🌐 Supports deployment at [Heroku](https://www.heroku.com/platform) and [Render](https://render.com)


## Usage

### Prerequisites
- Ruby 3.3
  - Check the [.ruby-version](.ruby-version)
- PostgreSQL 16.3
- Bun

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

3. Replace `Shore` with your application's name. Let's say you want to name your project as `AirKit`

```
./bin/replace_name AirKit
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