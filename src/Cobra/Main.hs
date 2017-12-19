{-# LANGUAGE FlexibleContexts #-}
module Cobra.Main
    ( doBenchmark
    ) where

import qualified Control.Foldl as F
import Control.Monad.Except
import Control.Monad.IO.Class
import Data.Text (Text)
import Turtle

import Cobra.Builder
import Cobra.Store
import Cobra.Reporter
import Cobra.Notifier

import Cobra.Error
import Cobra.Data

doBenchmark :: (MonadIO m, MonadError Error m, Builder b m, Store s m, Reporter r m, Notifier n m)
            => b -> s -> r -> n -> m ()
doBenchmark b s r n = do
    cmd <- build b
    bmData <- runBenchmark cmd
    let bmDataPoints = generateDataPoints bmData
    store s bmDataPoints
    report <- generateReport r bmDataPoints
    notify n report
    
runBenchmark :: (MonadIO m, MonadError Error m) => Command -> m BenchmarkData
runBenchmark (Command cmdText) = do
    fold (runCmdShell cmdText) F.list
    where 
        runCmdShell :: Text -> Shell TestResult
        runCmdShell cmd = do
            line <- inproc cmd [] empty
            let testResult = parseTestResult line
            return testResult
        parseTestResult :: Line -> TestResult
        parseTestResult = undefined

generateDataPoints :: BenchmarkData -> [DataPoint]
generateDataPoints = undefined
