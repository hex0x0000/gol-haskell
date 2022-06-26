module Main where

import System.Exit ( exitFailure )
import System.Environment ( getArgs )
import Utils ( parseData, clear, sleep, printMat )
import GOL ( newGen )
import qualified Data.ByteString.Lazy

loop :: [[Bool]] -> Float -> IO ()
loop m s
    | null m = exitFailure
    | otherwise = do
        clear
        let matrix = newGen m
        printMat matrix
        sleep s
        loop matrix s

main :: IO ()
main = do
  args <- getArgs  
  if null args
    then do
      putStrLn "You must specify a JSON file with matrix data."
      exitFailure
    else do
      file <- Data.ByteString.Lazy.readFile (head args)
      case (parseData file) of
        Just (first_gen, delay) -> do
          printMat first_gen
          sleep delay
          loop first_gen delay
        Nothing -> do
          putStrLn "Failed to parse JSON."
          exitFailure
