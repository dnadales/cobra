{-# LANGUAGE Arrows #-}

module Cobra.PostgresStore where

import           Opaleye ( Table, Column, Query
                         , tableWithSchema, tableColumn, queryTable
                         , runQuery
                         , PGInt4, PGText, PGTimestamptz
                         , pgUTCTime
                         , runInsertMany)
import           Data.Profunctor.Product (ProductProfunctor, p2, p3)
import           Data.Profunctor.Product.Default (Default, def)
import           Control.Arrow (returnA)
import           Database.PostgreSQL.Simple (Connection, ConnectInfo)
import qualified Database.PostgreSQL.Simple as PGS
import           Data.Time.Clock
import           Data.Text (Text)
import           Data.Profunctor (lmap)
import           Data.Profunctor.Product ((***$), (****))
import           Data.Pool
import           Control.Monad.IO.Class

data PostgresStore = PostgresStore
    { pool :: Pool Connection } deriving (Show)

mkPostgresStore :: MonadIO m => ConnectInfo -> m PostgresStore
mkPostgresStore ci = liftIO $
    PostgresStore <$> createPool (PGS.connect ci)
                                 PGS.close
                                 subPools
                                 keepAlive
                                 maxConns
    where
      subPools  = 1 -- ^ Only one sub-pool.
      keepAlive = 2 -- ^ Keep an unused connection open for 2 seconds. 
      maxConns  = 5 -- ^ Maximum number of connections that can be open.

data Benchmark' a b c = Benchmark
    { bmId :: a
    , bmVersionId :: b
    , bmDateTaken :: c
    }

data Mono = Mono

type Benchmark = Benchmark' Int Text UTCTime -- TODO: see to what haskell type SERIAL is written
type BenchmarkReadColumn = Benchmark' (Column PGInt4) (Column PGText) (Column PGTimestamptz)
-- | Type of writes to the table. The don't have to (and shouldn't?) supply a
-- value for the id field.
type BenchmarkWriteColumn = Benchmark' (Maybe (Column PGInt4)) (Column PGText) (Column PGTimestamptz)

-- | We define `pBenchmark` by hand to avoid having to use `TemplateHaskell`.
--
-- See https://hackage.haskell.org/package/product-profunctors-0.8.0.3/docs/Data-Profunctor-Product-TH.html
pBenchmark :: ProductProfunctor p
           => Benchmark' (p a a') (p b b') (p c c')
           -> p (Benchmark' a b c) (Benchmark' a' b' c')
pBenchmark f = Benchmark ***$ lmap bmId (bmId f)
                         **** lmap bmVersionId (bmVersionId f)
                         **** lmap bmDateTaken (bmDateTaken f)

-- | We also define a `Default` instance that involved `Benchmark'` to avoid
-- using `TemplateHaskell`.
instance (ProductProfunctor p, Default p a a', Default p b b', Default p c c')
    => Default p (Benchmark' a b c) (Benchmark' a' b' c') where
    def = pBenchmark (Benchmark def def def)

benchmarksTable :: Table BenchmarkWriteColumn BenchmarkReadColumn
benchmarksTable = tableWithSchema "cobra_test" "benchmarks"
                         (pBenchmark Benchmark 
                                 { bmId = tableColumn "benchmarkid"
                                 , bmVersionId = tableColumn "versionid"
                                 , bmDateTaken = tableColumn "datetaken"
                                 })

benchmarksQuery :: Query BenchmarkReadColumn
benchmarksQuery = queryTable benchmarksTable

getAllBenchmarks :: PostgresStore -> IO [Benchmark]
getAllBenchmarks PostgresStore { pool } = withResource pool $ \conn ->
    runQuery conn benchmarksQuery

addBenchmark :: PostgresStore -> IO ()
addBenchmark PostgresStore { pool } = withResource pool $ \conn -> do
    currTime <- getCurrentTime
    n <- runInsertMany conn benchmarksTable [Benchmark Nothing "boo" (pgUTCTime currTime)]
    putStrLn $ "Added " ++ show n ++ " benchmarks." 
    
-- * Examples

-- > import Database.PostgreSQL.Simple
-- > pgs <- mkPostgresStore defaultConnectInfo { connectUser = "damian" , connectDatabase = "cobra_test", connectPassword = ":testme!" }
-- > res <- getAllBenchmarks pgs
