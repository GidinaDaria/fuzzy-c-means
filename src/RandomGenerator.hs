module RandomGenerator
where

import System.Random
import Data.Vector as V
import Data.List.Split as S
import Data.List as L

getRandomDoubleList :: StdGen -> Int -> Int -> [Double]
getRandomDoubleList gen i j = Prelude.take ((*) i j) (randoms gen :: [Double])

getRandomDoubleListOfLists :: StdGen -> Int -> Int -> [[Double]]
getRandomDoubleListOfLists gen i j = S.chunksOf j (getRandomDoubleList gen i j)

convertToVectorOfVectors :: [[Double]] -> V.Vector (V.Vector Double)
convertToVectorOfVectors m = V.fromList(Prelude.map (\x -> V.fromList(x)) m)

normalizeVectorOfVectors :: V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
normalizeVectorOfVectors m = V.map (\x -> V.map (\elem -> elem/(V.sum x)) x) m

getRandomMatrix :: StdGen -> Int -> Int -> V.Vector (V.Vector Double)
getRandomMatrix gen i j = normalizeVectorOfVectors (convertToVectorOfVectors (getRandomDoubleListOfLists gen i j))

generateRandomCenters :: StdGen -> Int -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
generateRandomCenters gen c objects = 
  let
    randomIndexes = Prelude.take c $ L.nub (randomRs (0, (V.length (objects)) - 1) gen :: [Int])
  in
    --ifilter :: (Int -> a -> Bool) -> Vector a -> Vector a
    --elem :: (Foldable t, Eq a) => a -> t a -> Bool
    V.ifilter (\index _ -> L.elem index (randomIndexes)) objects