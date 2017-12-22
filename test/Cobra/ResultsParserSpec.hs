{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}
module Cobra.ResultsParserSpec where

import qualified Data.Map as Map
import qualified Data.Text as T
import           Data.Text (Text)
import           Data.Monoid

import           Test.Hspec
import           Test.QuickCheck

    
import           Cobra.ResultsParser
import           Cobra.Data
import           Cobra.DataGen ()

asTestResult :: TestName -> MetricValues -> Text
asTestResult (TestName tn) (MetricValues mVals) =
    quote tn <> " " <> T.concat (map mvAsResult (Map.toList  mVals))
    where
      mvAsResult :: (MetricName, Double) -> Text
      mvAsResult (MetricName mn, d) = quote mn <> " " <> T.pack (show d)

quote :: Text -> Text
quote t = "\"" <> t <> "\""

spec :: Spec
spec =
    describe "Benchmark output line" $ do
        it "Parses test results without quotes" $ property $
            \name mval ->            
                Right (name, mval) === parseBOL (asTestResult name mval)

        it "Parses escaped strings" $ do
            let line = "\"My \\\"benchmark\\\"\" \"The \\\"value\\\"\" 239.0"
                Right (name, mval) = parseBOL line
            name `shouldBe` "My \"benchmark\""
            mval `shouldBe` MetricValues [("The \"value\"", 239.0)]

