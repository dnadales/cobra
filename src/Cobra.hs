{-# LANGUAGE OverloadedStrings #-}
module Cobra where

import           ClassyPrelude       (unlessM)
import           CobraOpts
import           Control.Applicative
import           Data.Semigroup      ((<>))
import           Data.String
import qualified Data.Text           as T
import           Turtle.Line
import           Turtle.Prelude
import           Turtle.Shell

runBenchmarks :: CobraOpts -> IO ()
runBenchmarks opts = sh $ do
    unlessM (testpath cmdFP) $
        die ("Could not find an executable for '" <> cmd <> "'")
    line <- inproc cmd [] empty
    liftIO $ putStrLn $ "TODO: parse this: " ++ T.unpack (lineToText line)
    where
      cmd = T.pack (benchCmd opts)
      cmdFP = fromString (benchCmd opts)
