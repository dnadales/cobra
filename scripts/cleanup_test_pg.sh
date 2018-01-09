#!/bin/bash

## Call this from the root directory of this repository.

## TODO: use the `turtle` library to make everything a bit more type safe and
## consistent.
psql -f data/cleanup_test_data.sql -v user=$COBRA_TESTER -v test_schema=$COBRA_TEST_SCHEMA postgres
