-- | Central module that takes care of running benchmarks, and provides access
-- to the historical benchmark data.

module CobraKing
    ()
where



-- | Start the benchmarking process.
triggerBenchmark :: String -> IO ()
triggerBenchmark = undefined
--     Setup ->

data SetupData = GithubRepo URL CommitHash BuildCommand
               | Package InstallCommand
               | Local BuildCommand

setup :: SetupData -> IO ()
setup = undefined

runBenchmark :: Command -> IO BenchmarkData
runBenchmark = undefined

doBenchmark :: SetupData -> Command -> Config -> IO ()
doBenchmark dat cmd cfg = do
    setup dat
    bmData <- runBenchmark cmd
    let bmMetricValues = generateMetricValues (context dat) bmData
    store bmMetricValues
    report <- generateReport bmMetricValues
    alert report (alertTargets cfg)

fetchData :: Constraints -> IO [MetricValue]
fetchData consts = do
    fromStore consts

fetchReport :: Constraints -> IO Report
fetchReport consts = do
    bmMetricValues <- fromStore consts
    generateReport bmMetricValues
