# Use the official Ruby image as a base image
FROM ruby:2.7.7-slim

# Install dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    libpq-dev \
    nodejs \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

    # Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install yarn=1.22.5-1

# Set environment variables
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 18.20.3
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Node.js via nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION

# Create and set the working directory
WORKDIR /rails

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the dependencies
RUN gem install bundler -v 2.2.22 && bundle install

# Copy the rest of the application code, including the Rakefile
COPY . .

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Ensure the correct working directory
WORKDIR /rails

# Expose the port that the app runs on
EXPOSE 3000

# Set the entrypoint to the custom script
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

RUN bundle exec rake assets:precompile
