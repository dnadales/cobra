{-# LANGUAGE OverloadedStrings #-}
module Cobra where

import           ClassyPrelude        (Identity, unlessM)
import           CobraOpts
import           Control.Applicative  hiding ((<|>))
import           Control.Arrow
import qualified Control.Foldl        as Fold
import           Data.Either
import           Data.FileStore.Git
import           Data.FileStore.Types
import           Data.Maybe
import           Data.Semigroup       ((<>))
import           Data.String
import           Data.Text            (Text)
import qualified Data.Text            as T
import           Text.Parsec          hiding (Line, spaces)
import           Text.Parsec.Language
import           Text.Parsec.String
import           Text.Parsec.Token
import           Turtle.Line
import           Turtle.Prelude
import           Turtle.Shell

runBenchmarks :: CobraOpts -> IO ()
runBenchmarks opts = sh $ do
    -- Get the project-name to which the benchmarks belong, and revision id.
    -- For now we use the git-commit hash, which means that at the moment
    -- 'cobra' will only work with git repositories.
    ePn <- liftIO gitProjectName
    pn <- case ePn of
        Left errM -> die (T.pack errM)
        Right val -> return val
    liftIO $ putStrLn $ "TODO: store this project name: " ++ pn
    let fs = gitFileStore "."
    benchId <- liftIO $ latest fs ""
    liftIO $ putStrLn $ "TODO: store this revision: " ++ benchId
    unlessM (testpath cmdFP) $
        die ("Could not find an executable for '" <> cmd <> "'")
    line <- lineToString <$> inproc cmd [] empty
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

lineToString :: Line -> String
lineToString = T.unpack . lineToText

data BenchmarkResult = BenchmarkResult
    { name              :: String  -- ^ Name of the benchmark.
    , executionTime     :: Double  -- ^ Execution time for that benchmark (could be an average).
    , standardDeviation :: Double  -- ^ Standard deviation for the measurements.
    , r2                :: Double  -- ^ R^2 goodness-of-fit
    } deriving (Show)

parseOutput :: String -> Either ParseError BenchmarkResult
parseOutput = parse benchmarkResultP ""

benchmarkResultP :: Parser BenchmarkResult
benchmarkResultP = BenchmarkResult <$> strP
                                   <*> (whiteSpace lexer *> floatP)
                                   <*> (whiteSpace lexer *> floatP)
                                   <*> (whiteSpace lexer *> floatP)

floatP :: Parser Double
floatP = float lexer

lexer :: GenTokenParser String u Identity
lexer = makeTokenParser haskellDef

strP :: Parser String
strP = stringLiteral lexer

-- | Parse the repository name from the output given by the first line of `git remote -v`.
repoNameFromRemoteP :: Parser String
repoNameFromRemoteP = do
    _ <- originPart >> hostPart
    _ <- char ':'
    firstPart <- many1 alphaNum
    _ <- char '/'
    secondPart <- many1 alphaNum
    _ <- string ".git"
    return $ firstPart ++ "/" ++ secondPart
    where
      originPart = many1 alphaNum >> space
      hostPart =  many1 alphaNum
               >> (string "@" <|> string "://")
               >> many1 alphaNum `sepBy` char '.'

type Error = String

gitProjectName :: IO (Either Error String)
gitProjectName = do
    firstLine <- fold gitRemoteV Fold.head
    return $ maybe (Left errMsg) parseLine firstLine
    where
      gitRemoteV = inproc "git" ["remote", "-v"] empty
      parseLine = left show . parse repoNameFromRemoteP "" . lineToString
      errMsg = "Could not get git repository information for the current folder."



