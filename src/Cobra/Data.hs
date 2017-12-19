module Cobra.Data
    ( BenchmarkData
    , DataPoint (..)
    , TestResult (..)
    ) where

import Data.Text (Text)

data DataPoint = DataPoint
    { metric :: Text
    , value :: Double
    }

data TestResult = TestResult
    { testSuite :: Text
    , measurements :: [DataPoint]
    }

type BenchmarkData = [TestResult]
