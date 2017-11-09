module Main where

import           CobraOpts

main :: IO ()
main = do
    opts <- parseCmdLine
    print opts
