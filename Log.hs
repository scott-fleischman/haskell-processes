{-# LANGUAGE OverloadedStrings #-}

module Log where

import qualified Control.Exception as Exception
import           Data.Semigroup ((<>))
import           Data.Text (Text)
import qualified Data.Text.Encoding as Text.Encoding
import qualified System.Log.FastLogger as FastLogger

-- | A pair of functions for timed logging to stdout/stderr.
data Config = Config
  { logStdout :: Text -> IO ()
  , logStderr :: Text -> IO ()
  }

wrapConfig :: (Config -> IO ()) -> IO ()
wrapConfig action = do
  timeCache <- FastLogger.newTimeCache iso8601DateTimeFormat
  wrapLogging timeCache (FastLogger.LogStdout FastLogger.defaultBufSize)
    (\stdoutLogger -> wrapLogging timeCache (FastLogger.LogStderr FastLogger.defaultBufSize)
      (\stderrLogger -> action
        Config
        { logStdout = stdoutLogger
        , logStderr = stderrLogger
        }
      )
    )

-- | Example: 2018-03-05T17:10:03+0000
iso8601DateTimeFormat :: FastLogger.TimeFormat
iso8601DateTimeFormat = "%Y-%m-%dT%H:%M:%S%z"

wrapLogging :: IO FastLogger.FormattedTime -> FastLogger.LogType -> ((Text -> IO ()) -> IO ()) -> IO ()
wrapLogging timeCache logType action = do
  Exception.bracket
    (FastLogger.newTimedFastLogger timeCache logType)
    (\(_, releaseLogger) -> releaseLogger)
    (\(logger, _) -> do
      let logStrLn msg = logger (FastLogger.toLogStr . (<> " " <> Text.Encoding.encodeUtf8 msg <> "\n"))
      action logStrLn
    )
