-- | 

module Cobra.ShellRunner where

import           Control.Monad.IO.Class
import qualified Data.Map                as Map
import           qualified Control.Foldl as F
import           qualified Data.Text     as T
import           Turtle                         hiding (s)
import           Control.Monad.Except
import           Control.Exception

import           Cobra.Runner
import           Cobra.ResultsParser
import           Cobra.Data
import           Cobra.Builder
import           Cobra.Error
import           Cobra.CobraIO
    
data ShellRunner = ShellRunner

instance Runner ShellRunner CobraIO where
    runBenchmark _ (Command {cmdName}) =
        do
        assertCmdExists cmdName
        res <- liftIO $ gatherOutputFromCmd `catch` handler
        case res of
            Left errMsg -> throwError errMsg
            Right testResults -> return testResults
        where
          gatherOutputFromCmd :: IO (Either CobraError TestResults)
          gatherOutputFromCmd = do
              res <- fold (runCmdShell cmdName) F.list
              return $ Right $ TestResults $ Map.fromList res
    
          handler :: IOError -> IO (Either CobraError TestResults)
          handler ex = return $ Left $ mkError 1 (T.pack (show ex))
          
          runCmdShell :: Text -> Shell (TestName, MetricValues)
          runCmdShell cmd = do
              line <- inproc cmd [] empty
              tryParseBMLine line
    
          tryParseBMLine line =
              case parseBMLine (lineToText line) of
                  Left parseErr -> die $ T.pack (show parseErr)
                  Right res -> return res
    
