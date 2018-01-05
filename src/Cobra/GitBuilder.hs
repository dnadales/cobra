-- |

module Cobra.GitBuilder where

import           Data.Text (Text)
import           Data.Aeson.Types
import           GHC.Generics
import           Data.Yaml
import           Turtle
import           Data.Maybe
import           Control.Monad.Except

import           Cobra.Builder hiding (Command)
import           Cobra.CobraIO
import           Cobra.Error

newtype GitBuilder = GitBuilder
    { gitBuilderCfg :: CobraConfig
    }

data CobraConfig = CobraConfig
    { buildConfig :: Command
    , benchConfig :: Command
    } deriving (Eq, Show, Generic)

instance FromJSON CobraConfig where
    parseJSON = genericParseJSON defaultOptions
        { fieldLabelModifier = fieldsMapping
        , omitNothingFields  = True
        }
        where
          fieldsMapping "buildConfig" = "build"
          fieldsMapping "benchConfig" = "bench"
          fieldsMapping fld           = fld

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

-- | Read the @.cobra.yaml@ configuration file for cobra.
readConfig :: IO CobraConfig
readConfig = do
    res <- decodeFileEither ".cobra.yaml"
    case res of
        Left cfgErr -> error (show cfgErr)
        Right cfg   -> return cfg

instance Builder GitBuilder CobraIO where
    build gb = do
        let buildCmd = cmdName . buildConfig . gitBuilderCfg $ gb
        mPath <- which (fromText buildCmd)
        unless (isJust mPath)  (throwError $ cmdNotFound buildCmd)
        return undefined
            where
              cmdNotFound cmd = mkError 1 $ "Build command not found: " <> cmd

    versionIdentifier = undefined

    oldVersions = undefined
