{-# LANGUAGE GeneralizedNewtypeDeriving #-}
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
import Data.String


newtype VersionIdentifier = VersionIdentifier { getVersionText :: Text }
    deriving (Eq, Show)

newtype TestName = TestName { getTestName :: Text }
    deriving (Eq, Ord, IsString)

instance Show TestName where
    show (TestName n) = show n

newtype MetricName = MetricName { getMetricName :: Text }
    deriving (Eq, Ord, IsString)

instance Show MetricName where
    show (MetricName n) = show n

newtype MetricValues = MetricValues { values :: Map MetricName Double }
    deriving (Eq, Show)

newtype TestResults = TestResults { results :: Map TestName MetricValues }
    deriving (Eq, Show)

newtype MetricReferenceValues = MetricReferenceValues 
    { refValues :: Map MetricName (Double, VersionIdentifier)}
    deriving (Eq, Show)

newtype ReferenceResults = ReferenceResults
    { refResults :: Map TestName MetricReferenceValues }
    deriving (Eq, Show)
