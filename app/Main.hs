module Main where

import           Cobra
import           CobraOpts

main :: IO ()
main = do
    opts <- parseCmdLine
    runBenchmarks opts
