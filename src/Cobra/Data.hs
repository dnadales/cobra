module Cobra.Data
    ( MetricValues (..)
    , TestResults (..)
    , VersionIdentifier (..)
    , ReferenceResults (..)
    -- , MetricReferenceValues (..)
    ) where

import Data.Text (Text)
import Data.Map (Map)

data MetricValues = MetricValues { values :: Map Text Double }

data TestResults = TestResults { results :: Map Text MetricValues }

data MetricReferenceValues = MetricReferenceValues 
    { refValues :: Map Text (Double, VersionIdentifier)}

data ReferenceResults = ReferenceResults
    { refResults :: Map Text MetricReferenceValues }

newtype VersionIdentifier = VersionIdentifier { getVersionText :: Text }