#!/bin/bash
# This script runs the tests on Heroku CI

git clone -b "$HEROKU_TEST_RUN_BRANCH" --single-branch https://github.com/SalesforceFoundation/statusite statusite_checkout
cd statusite_checkout
git reset --hard $HEROKU_TEST_RUN_COMMIT_VERSION
export DJANGO_SETTINGS_MODULE=config.settings.test
coverage run $(which pytest) --tap-stream
exit_status=$?
coveralls
if [ "$exit_status" != "0" ]; then
    exit $exit_status
fi
