{-# LANGUAGE FlexibleContexts #-}
module Cobra.Main
    ( doBenchmark
    ) where

import qualified Control.Foldl              as F
import qualified Data.Map             as Map
import           Control.Monad.Except
import           Data.Text (Text)
import           Turtle hiding (s)

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
    vId <- versionIdentifier b
    store s bmData vId
    history <- oldVersions b
    refResult <- getReferenceResult s history
    report <- generateReport r bmData refResult
    notify n report
    
runBenchmark :: (MonadIO m, MonadError Error m) => Command -> m TestResults
runBenchmark (Command cmdText) = do -- TODO: verify the command exists
    res <- fold (runCmdShell cmdText) F.list
    return $ TestResults $ Map.fromList res
    where 
        runCmdShell :: Text -> Shell (Text, MetricValues)
        runCmdShell cmd = do
            line <- inproc cmd [] empty
            let testResult = parseTestResult line
            return testResult
        parseTestResult :: Line -> (Text, MetricValues)
        parseTestResult = undefined
