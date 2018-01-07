-- | 

module Cobra.CobraIO
    ( CobraIO(..)
    , assertCmdExists
    , throwCobraError
    ) where

import           Control.Monad.Except
import           Turtle
import           Data.Maybe
import           Data.Text (Text)

import           Cobra.Error

newtype CobraIO a = CobraIO { runCobraIO :: ExceptT CobraError IO a}
    deriving (Functor, Applicative, Monad, MonadIO, MonadError CobraError)

assertCmdExists :: Text -> CobraIO ()
assertCmdExists cmdName = do
    mPath <- liftIO $ which (fromText cmdName)
    unless (isJust mPath) (throwCobraError cmdNotFound)
    where
      cmdNotFound = "Command not found: " <> cmdName

throwCobraError :: Text -> CobraIO a
throwCobraError msg = throwError $ mkError 1 msg
