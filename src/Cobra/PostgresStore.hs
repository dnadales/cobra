{-# LANGUAGE Arrows #-}

module Cobra.PostgresStore where

import           Opaleye ( Table, Column, Query
                         , table, tableColumn, queryTable
                         , runQuery
                         , PGInt4, PGText, PGTimestamptz)
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
type BenchmarkColumn = Benchmark' (Column PGInt4) (Column PGText) (Column PGTimestamptz)

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

benchmarksTable :: Table BenchmarkColumn BenchmarkColumn
benchmarksTable = table "benchmarks"
                         (pBenchmark Benchmark 
                                 { bmId = tableColumn "benchmarkid"
                                 , bmVersionId = tableColumn "versionid"
                                 , bmDateTaken = tableColumn "datetaken"
                                 })

benchmarksQuery :: Query BenchmarkColumn
benchmarksQuery = queryTable benchmarksTable

getAllBenchmarks :: PostgresStore -> IO [Benchmark]
getAllBenchmarks PostgresStore { pool } = withResource pool $ \conn ->
    runQuery conn benchmarksQuery

-- * Examples

-- > pgs <- mkPostgresStore defaultConnectInfo { connectUser = "damian" , connectDatabase = "cobra_test", connectPassword = "pipo" }
-- > getAllBenchmarks pgs
