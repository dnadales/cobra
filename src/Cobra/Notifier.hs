{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
module Cobra.Notifier
    ( Notifier (..)
    ) where

import Cobra.Reporter

class Monad m => Notifier n m where
    notify :: n -> Report -> m ()
