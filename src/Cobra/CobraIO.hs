-- | 

module Cobra.CobraIO
    ( CobraIO(..)
    , assertCmdExists
    ) where

import           Control.Monad.Except
import           Turtle
import           Data.Maybe
import           Data.Text (Text)

import           Cobra.Error

newtype CobraIO a = CobraIO { runShell :: ExceptT CobraError IO a}
    deriving (Functor, Applicative, Monad, MonadIO, MonadError CobraError)

assertCmdExists :: Text -> CobraIO ()
assertCmdExists cmdName = do
    mPath <- liftIO $ which (fromText cmdName)
    unless (isJust mPath) (throwError cmdNotFound)
    where
      cmdNotFound :: CobraError
      cmdNotFound = mkError 1 $ "Command not found: " <> cmdName
