{-# LANGUAGE OverloadedStrings #-}

import           Control.Lens
import           Criterion.Main
import           Criterion.Types
import           Data.Aeson.Lens
import qualified Data.ByteString.Lazy as B
import           System.IO.Temp



import           Lib

main :: IO ()
main = do
    fp <- emptySystemTempFile "benchmark-results.json"
    defaultMainWith (config fp)
        [ bench "100 numbers" $ nfIO $ saveNToFile 100 "bench100.txt"
        , bench "1000 numbers" $ nfIO $ saveNToFile 1000 "bench1000.txt"
        , bench "10000 numbers" $ nfIO $ saveNToFile 10000 "bench10000.txt"
        ]
    bs <- B.readFile fp
    print $ bs ^.. values
        . nth 0
        . key "reportAnalysis"
        . key "anMean"
        . key "estPoint"
        . _Double
    where
      config fp = defaultConfig { jsonFile = Just fp }

