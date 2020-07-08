#!/bin/bash

# See https://github.com/travis-ci/travis-ci/issues/1066
# Fail if one of the commands of this script fails
set -e

docker-compose up -d
exit_codes=$(docker-compose ps -q | xargs docker inspect -f '{{ .Name }} exited with status Exit {{ .State.ExitCode }}')
errors=$(echo "$exit_codes" | egrep -v "Exit 0" | wc -l)
if (($errors > 0)); then
    echo "$exit_codes" | egrep -v "Exit 0"
    exit 1
fi

set +e
