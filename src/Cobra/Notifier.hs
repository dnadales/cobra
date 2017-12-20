{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
module Cobra.Notifier
    ( Notifier (..)
    ) where

import Control.Monad.Except

import Cobra.Error
import Cobra.Reporter

class MonadError Error m => Notifier n m where
    notify :: n -> Report -> m ()
