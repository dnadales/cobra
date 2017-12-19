-- | Parser for the output of the benchmark programs.

module Cobra.ResultsParser
    ( parseTestResult
    ) where

import qualified Data.Map as Map
import qualified Data.Text as T
import           Data.Text (Text)
import           Text.Parsec
import           Text.Parsec.Language
import           Text.Parsec.Token
import           Text.Parsec.String
import           ClassyPrelude  (Identity)

import           Cobra.Data

-- TODO: test like this
-- > show $ parseTestResult "\"hello\" 10.0 \"x\""

parseTestResult :: Text -> Either ParseError (TestName, MetricValues)
parseTestResult = parse testResultP "" . T.unpack

lexer :: GenTokenParser String u Identity
lexer = makeTokenParser haskellDef

strP :: Parser String
strP = stringLiteral lexer

floatP :: Parser Double
floatP = float lexer

metricsP :: Parser [(MetricName, Double)]
metricsP = many1 measurementP

measurementP :: Parser (MetricName, Double)
measurementP = flip (,) <$> floatP <*> metricNameP

metricNameP :: Parser MetricName
metricNameP = MetricName . T.pack <$> strP

metricValuesP :: Parser MetricValues
metricValuesP = (MetricValues . Map.fromList) <$> metricsP

testResultP :: Parser (TestName, MetricValues)
testResultP = (,) <$> testNameP <*> metricValuesP

testNameP  :: Parser TestName
testNameP = TestName . T.pack <$> strP
