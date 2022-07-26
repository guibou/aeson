{-# LANGUAGE ScopedTypeVariables #-}

import Data.Aeson
import System.Environment
import Control.DeepSeq (force)
import Control.Exception

-- | This program takes a filename as argument and decode its content as a Value
-- Run it with a huge json file with and without the "caching" support and see
-- the difference of peak memory usage.
main :: IO ()
main = do
  (filename:_) <- getArgs
  print filename
  e <- eitherDecodeFileStrict' filename

  case e of
    Left err -> print err
    Right (mdl :: Value) -> do
      -- We just force in order to be sure that there is no remaining thunk
      _ <- evaluate (force mdl)
      putStrLn "Parsing done"
