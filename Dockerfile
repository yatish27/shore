ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim
RUN <<EOF
apt-get update 
apt-get install -y build-essential libpq-dev curl unzip
EOF

ARG BUN_VERSION=1.1.8
ENV BUN_INSTALL=/usr/local/bun
ENV PATH=/usr/local/bun/bin:$PATH
RUN curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}"

WORKDIR /tmp
ADD Gemfile .
ADD Gemfile.lock .
RUN gem install bundler -v 2.5.10
RUN bundle install

WORKDIR /app
ADD . /app

RUN bun install 

RUN bin/rails assets:precompile

ENV PORT 3000
EXPOSE $PORT

CMD rails s -b 0.0.0.0 -p $PORT
