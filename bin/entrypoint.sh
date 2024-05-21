#!/bin/bash
set -e

# If the RUN_RAKE_TASK environment variable is set, run the specified rake task
if [ -n "$RUN_RAKE_TASK" ]; then
  echo "Running rake task: $RUN_RAKE_TASK"
  bundle exec rake $RUN_RAKE_TASK
fi

# Execute the container's main process (CMD)
exec "$@"
