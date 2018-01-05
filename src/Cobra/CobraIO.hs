-- | 

module Cobra.CobraIO where

import           Control.Monad.Except

import           Cobra.Error

newtype CobraIO a = CobraIO { runShell :: ExceptT CobraError IO a}
    deriving (Functor, Applicative, Monad, MonadIO, MonadError CobraError)
