module Cobra.Data
    ( MetricValues (..)
    , TestResults (..)
    , VersionIdentifier (..)
    , ReferenceResults (..)
    , MetricReferenceValues (..)
    ) where

import Data.Text (Text)
import Data.Map (Map)

newtype MetricValues = MetricValues { values :: Map Text Double }

newtype TestResults = TestResults { results :: Map Text MetricValues }

newtype MetricReferenceValues = MetricReferenceValues 
    { refValues :: Map Text (Double, VersionIdentifier)}

newtype ReferenceResults = ReferenceResults
    { refResults :: Map Text MetricReferenceValues }

newtype VersionIdentifier = VersionIdentifier { getVersionText :: Text }
