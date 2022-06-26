{-# LANGUAGE DeriveGeneric #-}
module Utils
    ( replace,
      replaceMat,
      makeMatrix,
      printMat,
      count,
      parseData,
      clear,
      sleep
    ) where

import Data.Foldable ( forM_ )
import Data.Aeson ( decode, FromJSON )
import System.Process ( system )
import System.Info ( os )
import Control.Concurrent ( threadDelay )
import System.Exit ( ExitCode, exitSuccess )
import Data.ByteString.Lazy ( ByteString )
import GHC.Generics

replace_ :: [a] -> Int -> Int -> [a] -> Int -> a -> [a]
replace_ newList i listSize list index value
    | i == listSize = newList
    | i == index = replace_ (newList ++ [value]) (i + 1) listSize list index value 
    | otherwise = replace_ (newList ++ [list !! i]) (i + 1) listSize list index value

replace :: [a] -> Int -> a -> [a]
replace list = replace_ [] 0 (length list) list

replaceMat :: [[a]] -> Int -> Int -> a -> [[a]]
replaceMat m y x v = replace m y (replace (m !! y) x v)

makeMatrix :: Int -> Int -> a -> [[a]]
makeMatrix y x val = replicate y (replicate x val)

printCell :: Bool -> Char
printCell False = '.'
printCell True = '#'

mapRow :: [Bool] -> [Char]
mapRow = map printCell

printMat :: [[Bool]] -> IO ()
printMat m = forM_ (map mapRow m) putStrLn

count :: Eq a => a -> [a] -> Int
count x = length . filter (x==)

clear :: IO ExitCode
clear = case os of
  "darwin" -> system "clear"
  "freebsd" -> system "clear"
  "linux" -> system "clear"
  "netbsd" -> system "clear"
  "openbsd" -> system "clear"
  "mingw32" -> system "cls"
  _ -> do
    putStr "\ESC[2J"
    exitSuccess

sleep :: Float -> IO ()
sleep s = threadDelay (round (s * 1000000.0))

data Cell = Cell {
  x :: Int,
  y :: Int
} deriving (Show, Generic)
instance FromJSON Cell

data MatrixData = MatrixData {
  width :: Int,
  len :: Int,
  delay :: Float, -- in seconds
  cells :: [Cell]
} deriving (Show, Generic)
instance FromJSON MatrixData

setCells :: [[Bool]] -> [Cell] -> Int -> Int -> [[Bool]]
setCells m c l inv_l
  | inv_l == 0 = m
  | otherwise = setCells (replaceMat m (y (c !! l)) (x (c !! l)) True) c (l + 1) (inv_l - 1)

parseData :: ByteString -> Maybe ([[Bool]], Float)
parseData j = do
  let md = decode j :: Maybe MatrixData
  case md of
    Just md -> do
      let matrix = makeMatrix (len md) (width md) False
      Just ((setCells matrix (cells md) 0 (length (cells md))), (delay md))
    Nothing -> Nothing
