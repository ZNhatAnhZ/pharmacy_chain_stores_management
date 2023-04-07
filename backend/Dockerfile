FROM ruby:3.0.2-alpine
RUN apk add \
  openssl-dev \
  build-base \
  mysql-client \
  mysql-dev \
  tzdata \
  vim

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .

ENTRYPOINT ["sh", "docker-entrypoint.sh"]
