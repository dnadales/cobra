{-# LANGUAGE FlexibleContexts #-}
module Cobra.Main
    ( doBenchmark
    ) where


import Control.Monad.Except

import Cobra.Builder
import Cobra.Store
import Cobra.Reporter
import Cobra.Notifier

import Cobra.Error
import Cobra.Data

doBenchmark :: (MonadError Error m, Builder b m, Store s m, Reporter r m, Notifier n m)
            => b -> s -> r -> n -> m ()
doBenchmark b s r n = do
    cmd <- build b
    bmData <- runBenchmark cmd
    let bmDataPoints = generateDataPoints bmData
    store s bmDataPoints
    report <- generateReport r bmDataPoints
    notify n report
    
runBenchmark :: MonadError Error m => Command -> m BenchmarkData
runBenchmark = undefined

generateDataPoints :: BenchmarkData -> DataPoints
generateDataPoints = undefined
