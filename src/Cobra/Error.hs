module Cobra.Error
    ( Error() -- NOTE: clients of this module shouldn't be able to create
              -- @Error ExitSuccess@, so don't expose the @ErrorCode@
              -- constructor.
    , errorCode
    , message
    , mkError
    ) where

import System.Exit
import Data.Text (Text)

data Error = Error
    { errorCode :: ExitCode
    , message :: Text
    }

mkError :: Int -> Text -> Error
mkError code = Error (ExitFailure code)
