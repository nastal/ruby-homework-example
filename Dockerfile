FROM ruby:3.3.0-alpine

RUN apk add --update --virtual runtime-dependencies \
  build-base \
  git \
  libpq-dev  \
  gcompat \
  tzdata \
  bash \
  && rm -rf /var/cache/apk/*

EXPOSE 3300

WORKDIR /app

COPY . /app

RUN gem install bundler

RUN bundle install
