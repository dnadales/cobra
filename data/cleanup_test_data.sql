-- Call this script as follows:
--
--     psql -f cleanup_test_data.sql \
--          -v user=$COBRA_TESTER \
--          -v test_schema=$COBRA_TEST_SCHEMA \
--          postgres

DROP SCHEMA :test_schema CASCADE;
DROP ROLE :user;

