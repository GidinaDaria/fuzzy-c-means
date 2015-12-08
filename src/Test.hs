module Main
where

import qualified Data.Vector as V
import Test.HUnit
import RandomGenerator as RG
import FCM

main :: IO()
main = do
  let 
    checkHamming = TestCase (
                              assertEqual "Check hamming distance beetween [1,1,1,1] [0,1,0,0])" 3.0 
                              ( 
                                hammingDist (V.fromList [1.0,1.0,1.0,1.0]) (V.fromList [0.0,1.0,0.0,0.0])
                              )
                            )
    checkEvklid = TestCase (
                              assertEqual "Check evclid distance beetween [1,1,1,1] [0,1,0,0])" 1.7320508075688772 
                              ( 
                                evklidDist (V.fromList [1.0,1.0,1.0,1.0]) (V.fromList [0.0,1.0,0.0,0.0])
                              )
                            )
    matrixDistanceTest = TestCase (
                                    assertEqual "Check matrix" 7.0 
                                    ( 
                                      matrixDistance (RG.convertToVectorOfVectors [[1.0,1.0],[2.0,2.0]]) (RG.convertToVectorOfVectors [[3.0,2.0],[1.0,9.0]])
                                    ) 
                                  )
  counts <- runTestTT (TestList [checkHamming,checkEvklid,matrixDistanceTest] )   
  return ()