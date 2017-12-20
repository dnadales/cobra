{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
-- | Module that builds the command that will be run for benchmarks.

module Cobra.Builder
    ( Builder (..)
    , Command (..)
    ) where

import Control.Monad.Except
import Data.Text (Text)

import Cobra.Error
import Cobra.Data

newtype Command = Command { getCommandText :: Text }

class MonadError Error m => Builder b m where
    build :: b -> m Command
    versionIdentifier :: b -> m VersionIdentifier
    oldVersions :: b -> m [VersionIdentifier]
