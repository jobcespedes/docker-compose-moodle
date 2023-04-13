#!/bin/sh

# See https://github.com/travis-ci/travis-ci/issues/1066
# Fail if one of the commands of this script fails
set -e

git clone --branch MOODLE_401_STABLE --depth 1 https://github.com/moodle/moodle html

set +e
