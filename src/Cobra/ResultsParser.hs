{-# LANGUAGE OverloadedStrings #-}
-- | Parser for the output of the benchmark programs.

module Cobra.ResultsParser
    ( parseBOL
    ) where

import qualified Data.Map as Map
import qualified Data.Text as T
import           Data.Text (Text)
import           ClassyPrelude  (Identity)

import           Text.Parsec
import           Text.Parsec.Language
import           Text.Parsec.Token
import           Text.Parsec.String


import           Cobra.Data

-- | Parse the given benchmark output line.
parseBOL :: Text -> Either ParseError (TestName, MetricValues)
parseBOL = parse testResultP "" . T.unpack

lexer :: GenTokenParser String u Identity
lexer = makeTokenParser haskellDef

strP :: Parser String
strP = stringLiteral lexer

floatP :: Parser Double
floatP = (*) <$> signP <*> float lexer

signP :: Parser Double
signP = option 1 (char '-' *> return (-1))

metricsP :: Parser [(MetricName, Double)]
metricsP = many1 measurementP

measurementP :: Parser (MetricName, Double)
measurementP = (,) <$> metricNameP <*> floatP

metricNameP :: Parser MetricName
metricNameP = MetricName . T.pack <$> strP

metricValuesP :: Parser MetricValues
metricValuesP = (MetricValues . Map.fromList) <$> metricsP

testResultP :: Parser (TestName, MetricValues)
testResultP = (,) <$> testNameP <*> metricValuesP

testNameP  :: Parser TestName
testNameP = TestName . T.pack <$> strP
