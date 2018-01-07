-- |

module Cobra.GitBuilder where

import           Data.Aeson.Types
import           GHC.Generics
import           Data.Yaml
import           Turtle
import           Control.Monad.Except
import qualified Data.Text as T
import           Data.List

import           Cobra.Builder
import           Cobra.CobraIO
import           Cobra.Error
import           Cobra.Data

newtype GitBuilder = GitBuilder
    { gitBuilderCfg :: CobraConfig
    }

data CobraConfig = CobraConfig
    { buildCommand :: Command
    , benchCommand :: Command
    } deriving (Eq, Show, Generic)

instance FromJSON CobraConfig where
    parseJSON = genericParseJSON defaultOptions
        { fieldLabelModifier = fieldsMapping
        , omitNothingFields  = True
        }
        where
          fieldsMapping "buildCommand" = "build"
          fieldsMapping "benchCommand" = "bench"
          fieldsMapping fld            = fld

-- | Read the @.cobra.yaml@ configuration file for cobra.
readConfig :: IO CobraConfig
readConfig = do
    res <- decodeFileEither ".cobra.yaml"
    case res of
        Left cfgErr -> error (show cfgErr)
        Right cfg   -> return cfg

instance Builder GitBuilder CobraIO where
    build gb = do
        let bc = cmdName . buildCommand . gitBuilderCfg $ gb
            ba = cmdArgs . buildCommand . gitBuilderCfg $ gb
        assertCmdExists bc
        -- Build the command.
        ec <- proc bc ba empty
        unless (ec == ExitSuccess) (throwError $ buildFailure ec)
        return $ benchCommand . gitBuilderCfg $ gb
            where
              buildFailure ec = mkError 1 $
                  "Build command aborted with exit code: " <> T.pack (show ec)

    versionIdentifier _ = do
        (ec, out) <- procStrict "git" ["rev-parse", "HEAD"] empty
        unless (ec == ExitSuccess) $
            throwCobraError $ "Could not get the current version identifier "
            <> out <> "(" <> T.pack (show ec) <> ")"
        case removeEOL out of
            Nothing      ->
                throwCobraError $
                    "Unexpected output from the `git` command " <> out
            Just version ->
                return $ VersionIdentifier version
        where
          removeEOL txt =
              fst <$> uncons (T.lines txt)
              

    oldVersions = undefined
