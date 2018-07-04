{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Control.Concurrent
import qualified Control.Monad
import qualified Data.Text
import qualified Log
import qualified System.Environment

main :: IO ()
main = Log.wrapConfig $ \logConfig -> do
  args <- System.Environment.getArgs
  message <-
    case args of
      [] -> return "Hi"
      message : _ -> return $ Data.Text.pack message
  Control.Monad.forever $ do
    Log.logStdout logConfig message
    Control.Concurrent.threadDelay 1000000
