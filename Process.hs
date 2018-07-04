{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Control.Concurrent.Async
import qualified Data.ByteString.Lazy
import qualified Data.Text
import qualified Data.Text.Encoding
import           Formatting ((%))
import qualified Formatting
import           Prelude hiding (log)
import qualified System.Environment
import qualified System.IO
import qualified System.Log.FastLogger
import qualified System.Process.Typed

main :: IO ()
main = System.Log.FastLogger.withFastLogger (System.Log.FastLogger.LogStdout System.Log.FastLogger.defaultBufSize) $ \fastLogger -> do
  let log = fastLogger . System.Log.FastLogger.toLogStr . flip Data.Text.append "\n"
  (pathString, _) <- System.Process.Typed.readProcess_ "stack path --local-install-root"
  let
    pathText = Data.Text.strip . Data.Text.Encoding.decodeUtf8 . Data.ByteString.Lazy.toStrict $ pathString
    repeatPath = Formatting.sformat (Formatting.stext % "/bin/repeat") pathText
  print repeatPath

  let
    echoProcessLines prefix process = do
      line <- System.IO.hGetLine (System.Process.Typed.getStdout process)
      log $ Formatting.sformat (Formatting.stext % " " % Formatting.string) prefix line
      maybeExitCode <- System.Process.Typed.getExitCode process
      case maybeExitCode of
        Nothing -> echoProcessLines prefix process
        Just _ -> return ()

    makeConfig arg
      = System.Process.Typed.setStdin System.Process.Typed.closed
      . System.Process.Typed.setStdout System.Process.Typed.createPipe
      . System.Process.Typed.setStdout System.Process.Typed.closed
      $ System.Process.Typed.proc (Data.Text.unpack repeatPath) [arg]

    startProcess prefix arg = System.Process.Typed.withProcess (makeConfig arg) (echoProcessLines prefix)

  args <- System.Environment.getArgs
  let
    messages =
      case args of
        [] -> ["apple", "orange", "banana"]
        (_ : _) -> args
    pairs = zip (fmap (Data.Text.pack . show) [1 :: Int ..]) messages

  Control.Concurrent.Async.mapConcurrently_ (uncurry startProcess) pairs
