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

## PostgresSQL
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


## Bun
Visit [bun.sh](https://bun.sh/docs/installation) to learn about installation process

```
brew install oven-sh/bun/bun
```

After installing, check the version 

```
bun -v
```

## Overmind
Overmind is an alternative to Foreman. It requires tmux
[Overmind](https://github.com/DarthSim/overmind)

```
brew install tmux overmind
```

## Docker
Install docker using homebrew
```
brew install docker
```
Latest version of docker install docker compose along with it.

To install the docker desktop, visit https://www.docker.com/products/docker-desktop/