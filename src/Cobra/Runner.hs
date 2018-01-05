module Cobra.Runner (Runner (..)) where

import Cobra.Data
import Cobra.Builder

class Monad m => Runner r m where
    runBenchmark :: r -> Command -> m TestResults
