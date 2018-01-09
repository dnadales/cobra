-- Call this script as follows:
--
--     psql -f create_user_tester.sql \
--          -v passwd=$COBRA_TESTER_PASSWD \
--          -v user=$COBRA_TESTER \
--          -v test_schema=$COBRA_TEST_SCHEMA \
--          postgres
--
-- Source:
--     https://dba.stackexchange.com/questions/44678/how-to-set-password-for-postgresql-database-with-a-script
--     https://wiki.postgresql.org/wiki/First_steps
--

CREATE SCHEMA :test_schema;
CREATE ROLE :user WITH LOGIN PASSWORD :passwd;
GRANT ALL ON SCHEMA :test_schema TO :user;
-- GRANT ALL ON ALL TABLES IN SCHEMA :test_schema TO :user;
-- GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA :test_schema TO :user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA :test_schema TO :user;

ALTER DEFAULT PRIVILEGES IN SCHEMA :test_schema GRANT ALL ON TABLES TO :user;
ALTER DEFAULT PRIVILEGES IN SCHEMA :test_schema GRANT ALL ON SEQUENCES TO :user;

-- GRANT ALL PRIVILEGES ON DATABASE :user to :test_db;
-- GRANT USAGE, SELECT ON SEQUENCE benchmarks_benchmarkid_seq TO :user;
-- GRANT ALL ON SCHEMA :test_schema TO :user;

-- GRANT ALL ON ALL TABLES IN SCHEMA :test_schema TO :user;
