{-# LANGUAGE OverloadedStrings #-}

import           Control.Lens
import           Criterion.Main
import           Criterion.Types
import           Data.Aeson.Lens
import qualified Data.ByteString.Lazy as B
import           Data.Foldable
import           Data.List
import           Lib
import           System.IO.Temp

-- | Program that runs benchmarks using criterion, and parses and outputs the
-- results in a format that is understood by @cobra@.
main :: IO ()
main = do
    fp <- emptySystemTempFile "benchmark-results.json"
    defaultMainWith (config fp)
        [ bench "10 numbers" $ nfIO $ saveNToFile 10 "bench10.txt"
        , bench "100 numbers" $ nfIO $ saveNToFile 100 "bench100.txt"
        , bench "10000 numbers" $ nfIO $ saveNToFile 10000 "bench10000.txt"
        ]
    bs <- B.readFile fp
    let names = show <$> benchName bs
        means = show <$> value bs "anMean" _Double
        stDevs = show <$> value bs "anStdDev" _Double
        rSqares = show <$> rSquare bs
    traverse_ (putStrLn . unwords) $ transpose [names, means, stDevs, rSqares]
    where
      config fp = defaultConfig { jsonFile = Just fp }
      benchName bs = bs
                     -- The @^..@ operator comes from the lens package, which
                     -- is a synonym for @toListOf@.
                     ^.. nth 2
                     .   values
                     .   key "reportName"
                     .  _String
      value bs k t = bs
                     ^.. nth 2
                     . values
                     . key "reportAnalysis"
                     . key k
                     . key "estPoint"
                     . t
      rSquare bs =  bs
                    ^.. nth 2
                    . values
                    . key "reportAnalysis"
                    . key "anRegress"
                    . nth 0
                    . key "regRSquare"
                    . key "estPoint"
                    . _Double

