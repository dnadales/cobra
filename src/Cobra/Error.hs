module Cobra.Error
    ( Error() -- NOTE: clients of this module shouldn't be able to create
              -- @Error ExitSuccess@, so don't expose the @ErrorCode@
              -- constructor.
    , errorCode
    , message
    , mkErrorCode
    ) where

import System.Exit
import Data.Text (Text)

data Error = Error
    { errorCode :: ExitCode
    , message :: Text
    }

mkErrorCode :: Int -> Text -> Error
mkErrorCode code = Error (ExitFailure code)
