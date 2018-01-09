-- Call this script as follows:
--
--     psql -f create_test_tables.sql -v schema=$COBRA_PG_SCHEMA postgres
--
-- To list all databases:
--
--    postgres=# \l
--
-- To list all the schemas:
--
--    postgres=# \dn
--
-- To verify that the tables where created:
--
--     postgres=# \dt :schema.
--
CREATE TABLE IF NOT EXISTS :schema.benchmarks (
    benchmarkId SERIAL,
    versionId   VARCHAR     NOT NULL,
    dateTaken   TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (benchmarkId),
    UNIQUE      (versionId, dateTaken)
);

CREATE TABLE IF NOT EXISTS :schema.tests (
    testId SERIAL,
    testName VARCHAR,
    benchmarkId SERIAL REFERENCES :schema.benchmarks ON DELETE CASCADE,

    PRIMARY KEY (testId)
);

CREATE TABLE IF NOT EXISTS :schema.results (
    metricName VARCHAR NOT NULL,
    metricValue DOUBLE PRECISION,
    testId SERIAL REFERENCES :schema.tests ON DELETE CASCADE
);

