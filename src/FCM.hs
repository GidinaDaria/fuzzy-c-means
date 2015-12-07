module FCM
where

import qualified Data.Vector as V
import Data.List as L
import RandomGenerator as RG
import ArgumentParse as AP
import System.Random

--metrics
hammingDist :: V.Vector Double -> V.Vector Double -> Double
hammingDist list1 list2 = V.sum $ V.zipWith (\el1 el2 -> (abs) (el1 - el2)) list1 list2

evklidDist :: V.Vector Double -> V.Vector Double -> Double
evklidDist list1 list2 = sqrt (V.sum $ V.map (**2) $ V.zipWith (\el1 el2 -> el1 - el2) list1 list2)

getMetricFuntion:: AP.DistanceMetric -> (V.Vector Double -> V.Vector Double -> Double)
getMetricFuntion m =  if m == AP.Hamming
                        then hammingDist
                        else evklidDist

--
transposeMatrix :: V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
transposeMatrix m = RG.convertToVectorOfVectors (L.transpose ( RG.convertToListOfLists m))

findNewClusterCenters :: V.Vector (V.Vector Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
findNewClusterCenters objects belongings = 
  let 
    bTranspose = transposeMatrix belongings
    objTranspose = transposeMatrix objects
  in
    V.map (\ul -> V.map(\j -> V.sum (V.zipWith (\muil xij -> (muil**2) * xij) ul j) / (V.sum $ V.map (**2) ul)) objTranspose) (bTranspose)
    
getNewBelongingsMatrix :: (V.Vector Double -> V.Vector Double -> Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double) -> V.Vector (V.Vector Double)
getNewBelongingsMatrix distance objects clusterCenters = 
  let 
    sum xi vk = V.sum $ V.map (\vj -> ((distance xi vk) / (distance xi vj))**2) clusterCenters
  in V.map (\xi -> V.map (\vk -> if xi == vk then 1 else (1 / (sum xi vk))) clusterCenters) objects
  
matrixDistance :: V.Vector(V.Vector Double) -> V.Vector(V.Vector Double) -> Double
matrixDistance oldM newM = V.maximum  $ V.zipWith (\a b -> V.maximum $ V.zipWith (\l v -> abs $ l - v) a b) oldM newM

fcmMain :: StdGen -> Int -> Double -> V.Vector (V.Vector Double) -> AP.InitialMatrix -> AP.DistanceMetric -> V.Vector (V.Vector Double)
fcmMain gen clustersNumber precision objects initMatrix distMetric = 
  let
    metricFunc = getMetricFuntion distMetric
    belongingsMatrix = if initMatrix == AP.RandomCenter
                        then
                          let centers = RG.generateRandomCenters gen clustersNumber objects
                              metricFunc = getMetricFuntion distMetric
                          in getNewBelongingsMatrix metricFunc objects centers
                        else                     
                          RG.getRandomMatrix gen (V.length objects) clustersNumber
  in doClusterization metricFunc precision objects belongingsMatrix
  
doClusterization :: (V.Vector Double -> V.Vector Double -> Double) -> Double -> V.Vector(V.Vector Double) -> V.Vector(V.Vector Double) -> V.Vector(V.Vector Double)
doClusterization metricFunc precision objects belongingsMatrix =
  let centers = findNewClusterCenters objects belongingsMatrix
      newBelongingsMatrix = getNewBelongingsMatrix metricFunc objects centers 
  in if matrixDistance newBelongingsMatrix belongingsMatrix <= precision
     then newBelongingsMatrix
     else doClusterization metricFunc precision objects newBelongingsMatrix