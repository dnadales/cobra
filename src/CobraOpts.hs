-- | Command line parsing capabilities for @cobra@.
module CobraOpts where

import           Data.Semigroup      ((<>))
import           Options.Applicative

-- | Command line options for @cobra@
newtype CobraOpts = CobraOpts
    { -- | Executable command to run.
        benchCmd :: String
    } deriving (Show)

parseCmdLine :: IO CobraOpts
parseCmdLine = execParser opts
    where
      opts = info (optsP <**> helper)
                  ( fullDesc
                    <> progDesc "COntinuous Benchmarking, Reporting, and Alerting."
                  )

optsP :: Parser CobraOpts
optsP = CobraOpts <$> benchCmdP

benchCmdP :: Parser String
benchCmdP = strArgument (metavar "BENCH-CMD"
                         <> help "Command that runs the benchmarks.")


