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
    deriving (Show)

newtype TestName = TestName { getTestName :: Text }
    deriving (Eq, Ord)

instance Show TestName where
    show (TestName n) = show n

newtype MetricName = MetricName { getMetricName :: Text }
    deriving (Eq, Ord)

instance Show MetricName where
    show (MetricName n) = show n

newtype MetricValues = MetricValues { values :: Map MetricName Double }
    deriving (Show)

newtype TestResults = TestResults { results :: Map TestName MetricValues }
    deriving (Show)

newtype MetricReferenceValues = MetricReferenceValues 
    { refValues :: Map MetricName (Double, VersionIdentifier)}
    deriving (Show)

newtype ReferenceResults = ReferenceResults
    { refResults :: Map TestName MetricReferenceValues }
    deriving (Show)
