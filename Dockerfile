ARG RUBY_VERSION=3.3.0
FROM ruby:${RUBY_VERSION}-slim-bookworm

ENV RAILS_ENV="development" \
    BUNDLE_PATH="/bundle" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_DEPLOYMENT="0"

WORKDIR /app

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      imagemagick \
      libvips \
      libpq-dev \
      build-essential \
      git \
      tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle update net-pop --conservative && \
    bundle install --without production

RUN mkdir -p tmp && chmod 777 tmp

COPY . /app

COPY bin/wait-for-it.sh /app/bin/wait-for-it.sh
RUN chmod +x /app/bin/wait-for-it.sh

COPY bin/docker-entrypoint /app/bin/docker-entrypoint
RUN chmod +x /app/bin/docker-entrypoint

EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
