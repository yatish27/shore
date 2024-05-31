# Requirements

## Ruby
Use a Ruby version manager like [rbenv](https://github.com/rbenv/rbenv?tab=readme-ov-file#using-package-managers) to install ruby.
1. Install rbenv
```
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

## PostgreSQL
You can install PostgreSQL using [postgresapp.com](https://postgresapp.com) or Homebrew

### Using Homebrew

1. Install 

```bash
brew install postgresql@16
```

2. Add `psql` to `$PATH`

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"' >> ~/.bashrc
```
3. Start the server
```bash
brew services start postgresql@16

```
4. Create a `postgres` user

```sql
createuser -s postgres
```

5. Set the password for postgres

```
psql postgres
```
Within psql  

```sql
ALTER ROLE postgres WITH PASSWORD 'password';
```

### Using postgresapp.com

1. Visit [postgresapp.com](https://postgresapp.com) and download the app with PostgreSQL app.
2. Install the app.
3. Start the server and initialize the cluster using the UI

## Bun
```bash
brew install oven-sh/bun/bun
```

Visit [https://bun.sh/docs/installation](https://bun.sh/docs/installation) for more details

## Docker
Install docker using homebrew
```bash
brew install docker
```
The latest version of docker comes with docker-compose.

To install the docker desktop, visit https://www.docker.com/products/docker-desktop/
