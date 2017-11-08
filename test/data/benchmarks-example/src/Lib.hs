module Lib (
    saveNToFile
) where

import           Data.List

-- | Save the first N natural numbers to a file, separated by lines.
saveNToFile :: Int -> FilePath -> IO ()
saveNToFile n fp =
    writeFile fp $
      intercalate "\n" $
        show <$>  [0..n]
