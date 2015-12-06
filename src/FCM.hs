module FCM
where

import qualified Data.Vector as V
import Data.List as L
import RandomGenerator as RG

hammingDist :: V.Vector Double -> V.Vector Double -> Double
hammingDist list1 list2 = V.sum $ V.zipWith (\el1 el2 -> (abs) (el1 - el2)) list1 list2

evklidDist :: V.Vector Double -> V.Vector Double -> Double
evklidDist list1 list2 = sqrt (V.sum $ V.zipWith (\el1 el2 -> el1 - el2) list1 list2)

transposeMatrix :: V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
transposeMatrix m = RG.convertToVectorOfVectors (L.transpose ( RG.convertToListOfLists m))

findNewClusterCenters :: V.Vector (V.Vector Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
findNewClusterCenters objects belongings = 
  let 
    bTranspose = transposeMatrix belongings
    objTranspose = transposeMatrix objects
  in
    V.map (\ul -> V.map(\j -> V.sum (V.zipWith (\muil xij -> muil**2 * xij) ul j) / (V.sum ul)) ( objTranspose)) (bTranspose)
    
getNewBelongingsMatrix :: (V.Vector Double -> V.Vector Double -> Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
getNewBelongingsMatrix distance objects clusterCenters = 
  let 
    sum xi vk = V.sum $ V.map (\vj -> ((distance xi vk) / (distance xi vj))**2) clusterCenters
  in V.map (\xi -> V.map (\vk -> if xi == vk then 1 else 1 / (sum xi vk)) clusterCenters) objects
  
matrixDistance :: V.Vector(V.Vector Double) -> V.Vector(V.Vector Double) -> Double
matrixDistance oldM newM = V.maximum  $ V.zipWith (\a b -> V.maximum $ V.zipWith (\l v -> abs $ l - v) a b) oldM newM
