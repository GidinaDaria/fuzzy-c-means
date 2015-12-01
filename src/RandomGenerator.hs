module RandomGenerator
where

import System.Random
import Data.Vector as V

getRandomDoubleVector :: StdGen -> Int -> V.Vector(Double)
getRandomDoubleVector gen length = V.fromList (Prelude.take length (randoms gen :: [Double]))

--generate :: Int -> (Int -> a) -> Vector a

getRandomDoubleMatrix :: Int -> Int -> StdGen -> V.Vector(V.Vector(Double))
getRandomDoubleMatrix i j gen =
  let 
    genVector = getRandomDoubleVector gen j
    sum = V.sum (genVector)
    normalizedVector _ = V.map (\elem -> elem/(sum)) (genVector)
  in
    V.generate i (normalizedVector)