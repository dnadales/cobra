{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
-- |
-- Module      : Benchmark.Cobra.Store
-- Copyright   : (c) 2017 
--
-- License     : BSD-style
-- Maintainer  : damian.nadales@gmail.com
-- Stability   : experimental
-- Portability : GHC
--
-- Storage interface for cobra.

module Cobra.Store
    ( Store (..)
    ) where

import Cobra.Data

-- | A constraint on the data store.
class Store s m where
    store :: s -> TestResults -> VersionIdentifier -> m ()
    getReferenceResults :: s -> [VersionIdentifier] -> m ReferenceResults
