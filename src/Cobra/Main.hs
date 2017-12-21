{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
module Cobra.Main
    ( doBenchmark
    ) where

import           Control.Exception
import           Data.Maybe
import qualified Data.Text as T
import qualified Control.Foldl              as F
import qualified Data.Map             as Map
import           Control.Monad.Except
import           Turtle hiding (s)

import Cobra.Builder
import Cobra.Store
import Cobra.Reporter
import Cobra.Notifier

import Cobra.ResultsParser

import Cobra.Error
import Cobra.Data

doBenchmark :: (MonadIO m, MonadError Error m, Builder b m, Store s m, Reporter r m, Notifier n m)
            => b -> s -> r -> n -> m ()
doBenchmark b s r n = do
    cmd <- build b
    bmData <- runBenchmark cmd
    vId <- versionIdentifier b
    store s bmData vId
    history <- oldVersions b
    refResult <- getReferenceResult s history
    report <- generateReport r bmData refResult
    notify n report
    
runBenchmark :: (MonadIO m, MonadError Error m) => Command -> m TestResults
runBenchmark (Command cmdText) = do
    -- Check that the command exists
    mPath <- which (fromText cmdText)
    unless (isJust mPath) (throwError cmdNotFound)
    res <- liftIO $ gatherOutputFromCmd `catch` handler
    case res of
        Left errMsg -> throwError errMsg
        Right testResults -> return testResults

    where
      gatherOutputFromCmd :: IO (Either Error TestResults)
      gatherOutputFromCmd = do
          res <- fold (runCmdShell cmdText) F.list
          return $ Right $ TestResults $ Map.fromList res

      handler :: IOError -> IO (Either Error TestResults)
      handler ex = return $ Left $ mkError 1 (T.pack (show ex))

      cmdNotFound :: Error
      cmdNotFound = mkError 1 $ "Command not found: " <> cmdText
      
      runCmdShell :: Text -> Shell (TestName, MetricValues)
      runCmdShell cmd = do
          line <- inproc cmd [] empty
          tryParseBOL line

      tryParseBOL line =
          case parseBOL (lineToText line) of
              Left parseErr -> die $ T.pack (show parseErr)
              Right res -> return res
