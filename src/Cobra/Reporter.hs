{-# LANGUAGE MultiParamTypeClasses #-}
module Cobra.Reporter
    ( Reporter (..)
    , Report
    ) where

import Cobra.Data

data Report

class Monad m  => Reporter r m where
    generateReport :: r -> TestResults -> ReferenceResults -> m Report

