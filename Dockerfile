FROM ruby:3.2.2-slim

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libvips \
      nodejs \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy application code
COPY . .

# Ensure entrypoint is executable
RUN chmod +x bin/docker-entrypoint

# Precompile assets (safe to skip if not using assets)
RUN bundle exec rails assets:precompile || true

# Expose port for the Rails server
EXPOSE 3000

# Use entrypoint to run db:prepare automatically when starting server
ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
