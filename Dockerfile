FROM ruby:2.7.7

ENV RUBYOPT="-W0"

# System deps
RUN apt-get update -qq && apt-get install -y \
    curl \
    postgresql-client \
    build-essential \
    libpq-dev \
    nodejs \
    npm

# Yarn
RUN npm install -g yarn

WORKDIR /app

# Bundler
RUN gem install bundler -v 2.2.20

# Ruby deps
COPY Gemfile Gemfile.lock ./
RUN bundle _2.2.20_ install

# JS deps
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# App code
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
