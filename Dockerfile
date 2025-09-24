# syntax=docker/dockerfile:1.4
#
# --- Base Image Stage ---
# Use a slim, official Ruby image for development.
# Setting the ARG for consistency, but will use a fixed version for the base build.
ARG RUBY_VERSION=3.3.0
FROM ruby:${RUBY_VERSION}-slim-bookworm as base

# Install essential build packages, ImageMagick (libvips for modern Rails), and PostgreSQL client libraries
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libvips \
    git \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for the application
WORKDIR /app

# Set environment variables for development mode
ENV RAILS_ENV="development"

# --- Dependency Cache Stage (Bundler) ---
FROM base as dependency_cache

# Copy only the Gemfile and Gemfile.lock to leverage Docker layer caching
COPY Gemfile Gemfile.lock ./

# Install application gems including development and test groups
RUN bundle install

# --- Final Application Stage (Development Run) ---
FROM base as final

# Copy application code
COPY . /app

# Copy cached gems from the dependency stage
COPY --from=dependency_cache /usr/local/bundle /usr/local/bundle

# Copy and set executable permissions for the entrypoint script
# Note: Ensure bin/docker-entrypoint.sh is present in your repo
COPY bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod +x /usr/bin/docker-entrypoint.sh

# Expose the port used by the Rails server
EXPOSE 3000

# Set the entrypoint script to run migrations/setup before starting the server
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

# Set the command to run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
