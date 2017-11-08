import           Criterion.Main
import           Lib

main :: IO ()
main = defaultMain
    [ bench "100 numbers" $ nfIO $ saveNToFile 100 "bench100.txt"
    , bench "1000 numbers" $ nfIO $ saveNToFile 1000 "bench1000.txt"
    , bench "10000 numbers" $ nfIO $ saveNToFile 10000 "bench10000.txt"
    ]
