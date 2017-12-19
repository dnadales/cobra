module Cobra.Data
    ( MetricValues (..)
    , TestResults (..)
    , VersionIdentifier (..)
    , ReferenceResults (..)
    , MetricReferenceValues (..)
    , TestName (..)
    , MetricName (..)    
    ) where

import Data.Text (Text)
import Data.Map (Map)

newtype VersionIdentifier = VersionIdentifier { getVersionText :: Text }

newtype TestName = TestName { getTestName :: Text }
    deriving (Eq, Ord)

newtype MetricName = MetricName { getMetricName :: Text }

newtype MetricValues = MetricValues { values :: Map MetricName Double }

newtype TestResults = TestResults { results :: Map TestName MetricValues }

newtype MetricReferenceValues = MetricReferenceValues 
    { refValues :: Map MetricName (Double, VersionIdentifier)}

newtype ReferenceResults = ReferenceResults
    { refResults :: Map TestName MetricReferenceValues }

