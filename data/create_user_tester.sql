-- Call this script as follows:
--
--     psql -f create_user_tester.sql -v passwd=$COBRA_TESTER_PASSWD -v user=$COBRA_TESTER -v test_db=$COBRA_TESTDB
--
-- Source:
--     https://dba.stackexchange.com/questions/44678/how-to-set-password-for-postgresql-database-with-a-script
CREATE ROLE :user WITH PASSWORD :passwd;
GRANT ALL PRIVILEGES ON DATABASE :user to :cobra_test_db;
