#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rake db:migrate:up
