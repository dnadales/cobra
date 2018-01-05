-- | Module that builds the command that will be run for benchmarks.
module Cobra.Builder
    ( Builder (..)
    , Command (..)
    ) where

import Data.Text (Text)

import Cobra.Data

-- | Name of the command that must be used for running the benchmarks.
newtype Command = Command { getCommandText :: Text }

class Monad m => Builder b m where
    build :: b -> m Command
    versionIdentifier :: b -> m VersionIdentifier
    oldVersions :: b -> m [VersionIdentifier]
