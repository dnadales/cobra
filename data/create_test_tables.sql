CREATE TABLE IF NOT EXISTS benchmarks (
    benchmarkId SERIAL,
    versionId   VARCHAR     NOT NULL,
    dateTaken   TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (benchmarkId),
    UNIQUE      (versionId, dateTaken)
);

CREATE TABLE IF NOT EXISTS tests (
    testId SERIAL,
    testName VARCHAR,
    benchmarkId SERIAL REFERENCES benchmarks ON DELETE CASCADE,

    PRIMARY KEY (testId)
);

CREATE TABLE IF NOT EXISTS results (
    metricName VARCHAR NOT NULL,
    metricValue DOUBLE PRECISION,
    testId SERIAL REFERENCES tests ON DELETE CASCADE
);
