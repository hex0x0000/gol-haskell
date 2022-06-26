{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant if" #-}
module GOL (
    newGen
) where

import Utils ( count )

handleCell :: [[Bool]] -> Int -> Int -> Int -> Int -> Bool
handleCell m y x x_max y_max = do
  let neighbors = [if ((y - 1) >= 0 ) && ((x - 1) >= 0) then m !! (y - 1) !! (x - 1) else False,
        if (y - 1) >= 0                                 then m !! (y - 1) !! x else False,
        if (y - 1) >= 0 && (x + 1) < x_max              then m !! (y - 1) !! (x + 1) else False,
        if (x - 1) >= 0                                 then m !! y !! (x - 1) else False,
        if (x + 1) < x_max                              then m !! y !! (x + 1) else False,
        if (y + 1) < y_max && (x - 1) >= 0              then m !! (y + 1) !! (x - 1) else False,
        if (y + 1) < y_max                              then m !! (y + 1) !! x else False,
        if (y + 1) < y_max && (x + 1) < x_max           then m !! (y + 1) !! (x + 1) else False]
  let alive_neighbors = count True neighbors
  if m !! y !! x
    then not ((alive_neighbors < 2) || (alive_neighbors > 3))
    else alive_neighbors == 3

handleRow :: [[Bool]] -> [Bool] -> Int -> Int -> Int -> Int -> Int -> [Bool]
handleRow m r y x inv_x x_max y_max
  | inv_x == 0 = r
  | otherwise = handleRow m (r ++ [handleCell m y x x_max y_max]) y (x + 1) (inv_x - 1) x_max y_max

handleRows :: [[Bool]] -> [[Bool]] -> Int -> Int -> Int -> Int -> Int -> [[Bool]]
handleRows m nm y x inv_y x_max y_max
  | inv_y == 0 = nm
  | otherwise = handleRows m (nm ++ [handleRow m [] y 0 x x_max y_max]) (y + 1) x (inv_y - 1) x_max y_max

newGen :: [[Bool]] -> [[Bool]]
newGen m = do
    let y = length m
    let x = length (m !! 0)
    handleRows m [] 0 x y x y
