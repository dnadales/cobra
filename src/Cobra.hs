{-# LANGUAGE OverloadedStrings #-}
module Cobra where

import           ClassyPrelude        (Identity, unlessM)
import           CobraOpts
import           Control.Applicative
import           Data.Semigroup       ((<>))
import           Data.String
import qualified Data.Text            as T
import           Text.Parsec
import           Text.Parsec.Language
import           Text.Parsec.String
import           Text.Parsec.Token
import           Turtle.Line
import           Turtle.Prelude
import           Turtle.Shell

runBenchmarks :: CobraOpts -> IO ()
runBenchmarks opts = sh $ do
    unlessM (testpath cmdFP) $
        die ("Could not find an executable for '" <> cmd <> "'")
    line <- (T.unpack . lineToText) <$> inproc cmd [] empty
    let eRes = parseOutput line
    case eRes of
        Left pErr -> warnParseError line pErr
        Right res -> liftIO $ putStrLn $ "TODO: store" ++ show res
    where
      cmd = T.pack (benchCmd opts)
      cmdFP = fromString (benchCmd opts)
      warnParseError line pErr =
          liftIO $ putStrLn (  "WARNING: could not parse line: "
                            ++ line
                            ++ "(" ++ show pErr ++ ")"
                            )

data BenchmarkResult = BenchmarkResult
    { name              :: String  -- ^ Name of the benchmark.
    , executionTime     :: Double  -- ^ Execution time for that benchmark (could be an average).
    , standardDeviation :: Double  -- ^ Standard deviation for the measurements.
    , r2                :: Double  -- ^ R^2 goodness-of-fit
    } deriving (Show)

parseOutput :: String -> Either ParseError BenchmarkResult
parseOutput = parse benchmarkResultP ""

benchmarkResultP :: Parser BenchmarkResult
benchmarkResultP = BenchmarkResult <$> strParser
                                   <*> (whiteSpace lexer *> floatParser)
                                   <*> (whiteSpace lexer *> floatParser)
                                   <*> (whiteSpace lexer *> floatParser)

floatParser :: Parser Double
floatParser = float lexer

lexer :: GenTokenParser String u Identity
lexer = makeTokenParser haskellDef

strParser :: Parser String
strParser = stringLiteral lexer
