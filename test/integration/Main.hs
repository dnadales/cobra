-- import qualified Data.Text as T

-- import           Data.Functor.Identity
-- import           Control.Monad.Error.Class
-- import           Control.Monad.State.Lazy

-- import           Cobra.Main
-- import           Cobra.Builder
-- import           Cobra.Data
-- import           Cobra.Error

-- data DummyBuilder = DummyBuilder

-- newtype DummyM a = DummyM { runDummyM :: StateT [String] (Either CobraError) a }
--     deriving (Functor, Applicative, Monad, MonadError CobraError)

-- instance Builder DummyBuilder DummyM where
--     build _ = return $ Command "dummy!"
--     versionIdentifier _ = return $ VersionIdentifier "10"
--     oldVersions _ = return $ map (VersionIdentifier . T.pack . show) [0..9]

-- dummyBuilder :: DummyBuilder
-- dummyBuilder = undefined

-- dummyStore = undefined

-- dummyReporter = undefined

-- dummyNotifier = undefined

main :: IO ()
main = putStrLn "TODO: write integration tests here."
--    putStrLn $ show $
--       doBenchmark dummyBuilder dummyStore dummyReporter dummyNotifier 
