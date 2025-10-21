# Base image chứa Ruby
FROM ruby:3.2.2

# Cài đặt các gói cần thiết cho Rails, PostgreSQL, NodeJS, Yarn
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  git \
  vim \
  curl

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Copy Gemfile và Gemfile.lock vào container trước để cache bundle install
COPY Gemfile Gemfile.lock ./

# Cài đặt gem (bỏ development/test nếu build cho production)
RUN bundle install

# Copy toàn bộ mã nguồn vào container
COPY . .
# Precompile assets (nếu có frontend như sprockets hoặc webpacker)
# RUN bundle exec rake assets:precompile

# Expose port mặc định của Rails
EXPOSE 3000

# Command để khởi động server
CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -b 0.0.0.0 -p 3000"]
