#!/bin/sh

# See https://github.com/travis-ci/travis-ci/issues/1066
# Fail if one of the commands of this script fails
set -e

git clone --branch MOODLE_35_STABLE --depth 1 git://github.com/moodle/moodle html

set +e
