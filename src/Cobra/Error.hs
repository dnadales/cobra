module Cobra.Error
    ( CobraError() -- NOTE: clients of this module shouldn't be able to create
                   -- @Error ExitSuccess@, so don't expose the @ErrorCode@
                   -- constructor.
    , errorCode
    , message
    , mkError
    ) where

import System.Exit
import Data.Text (Text)

data CobraError = CobraError
    { errorCode :: ExitCode
    , message :: Text
    } deriving (Show, Eq)

mkError :: Int -> Text -> CobraError
mkError code = CobraError (ExitFailure code)
