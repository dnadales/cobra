module Cobra.Main
    ( doBenchmark
    ) where

import           Cobra.Builder
import           Cobra.Store
import           Cobra.Reporter
import           Cobra.Notifier
import           Cobra.Runner

doBenchmark :: ( Builder b m, Runner r m, Store s m, Reporter t m, Notifier n m)
            => b -> r -> s -> t -> n -> m ()
doBenchmark b r s t n = do
    cmd <- build b
    bmData <- runBenchmark r cmd
    vId <- versionIdentifier b
    store s bmData vId
    history <- previousVersions b
    refResult <- getReferenceResult s history
    report <- generateReport t bmData refResult
    notify n report
