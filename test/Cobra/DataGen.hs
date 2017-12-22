{-# OPTIONS_GHC -fno-warn-orphans #-}
-- | Generators for the types defined at @Data@.
module Cobra.DataGen where

import qualified Data.Map as Map

import           Data.Text (Text)
import qualified Data.Text as T
    
import           Test.QuickCheck

import           Cobra.Data

genValidName :: Gen Text
genValidName = 
    T.pack . filter allowed . getPrintableString <$> arbitrary
    where
      allowed = not . (`elem` ['\\', '\"'])


instance Arbitrary TestName where
    arbitrary = TestName <$> genValidName

instance Arbitrary MetricName where
    arbitrary = MetricName <$> genValidName

instance Arbitrary MetricValues where
    arbitrary = MetricValues . Map.fromList <$> listOf1 arbitrary
