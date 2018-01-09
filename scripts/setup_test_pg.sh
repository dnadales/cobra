#!/bin/bash

psql -f data/create_user_tester.sql \
     -v passwd=$COBRA_TESTER_PASSWD \
     -v user=$COBRA_TESTER \
     -v test_schema=$COBRA_TEST_SCHEMA \
     postgres

psql -f data/create_test_tables.sql -v schema=$COBRA_PG_SCHEMA postgres                            
