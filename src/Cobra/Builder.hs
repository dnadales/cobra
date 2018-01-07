-- | Module that builds the command that will be run for benchmarks.
module Cobra.Builder
    ( Builder (..)
    , Command (..)
    ) where

import           Data.Text (Text)
import           Data.Aeson.Types
import           GHC.Generics

import           Cobra.Data

data Command = Command
    { cmdName  :: Text
    , cmdArgs :: [Text]
    } deriving (Eq, Show, Generic)

instance FromJSON Command where
  parseJSON = genericParseJSON defaultOptions
      { fieldLabelModifier = fieldsMapping
      , omitNothingFields  = True
      }
      where
        fieldsMapping "cmdName" = "command"
        fieldsMapping "cmdArgs" = "arguments"
        fieldsMapping fld       = fld

class Monad m => Builder b m where
    build :: b -> m Command
    versionIdentifier :: b -> m VersionIdentifier
    previousVersions :: b -> m [VersionIdentifier]
