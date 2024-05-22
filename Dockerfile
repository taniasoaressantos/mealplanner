# Use a Ruby base image
FROM ruby:2.7.7-slim

# Install required packages and dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  curl \
  libpq-dev \
  nodejs \
  gnupg2 \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn

# Set environment variables
ENV RAILS_ENV=production
ENV NODE_ENV=production

# Set the working directory
WORKDIR /rails

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 2.2.22 && bundle install

# Copy the rest of the application code, including the Rakefile
COPY . .

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Install yarn packages
RUN yarn install --check-files

# Ensure webpack-cli is installed
RUN yarn add webpack-cli

# Precompile assets using the provided SECRET_KEY_BASE
ARG SECRET_KEY_BASE
RUN SECRET_KEY_BASE=${SECRET_KEY_BASE} bundle exec rake assets:precompile

# Expose the application port
EXPOSE 3000

# Start the main process
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
