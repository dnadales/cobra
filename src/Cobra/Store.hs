{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies  #-}
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

import Control.Monad.Except

import Cobra.Error
import Cobra.Data

-- | A constraint on the data store.
class MonadError Error m  => Store s m where
    type Query s

    store :: s -> [DataPoint] -> m ()
    fromStore :: s -> Query s -> m [DataPoint]
