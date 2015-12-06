import System.Random
import Data.Vector as V
import Data.List as L
import ArgumentParse as A
import RandomGenerator as R
import Options.Applicative as C
import CSVParser as P
import FCM

convertCsvArgs :: A.Args -> P.CSVSettings
convertCsvArgs args = P.CSVSettings {  
                                      ignoringFirstRowCsv = (ignoringFirstRow args),
                                      ignoringFirstColCsv = (ignoringFirstCol args),
                                      ignoringLastColCsv = (ignoringLastCol args)
                                    }

main = do

  let args = info (helper <*> parseArgs) fullDesc
  parseArgs <- execParser args
  print parseArgs
  
  --get objects from csv-file
  t <- P.readCsv (sourceFile parseArgs) (delimiter parseArgs)
  let objects = parseCsv (convertCsvArgs parseArgs) t 
  print $ (objects)

  --generate random centers
  gen <- newStdGen  
  let centers = R.generateRandomCenters gen (clustersCount parseArgs) objects
  print centers
  
  let value = R.getRandomMatrix gen (V.length objects) (clustersCount parseArgs)
  print value
  
  let newClCenters = findNewClusterCenters (objects) (value)
  print newClCenters
  --print $ hammingDist (V.fromList [1, 0, 0, 1, 1]) (V.fromList [0, 0, 1, 0, 1])
  
  
  let newBelongingMatrix = getNewBelongingsMatrix hammingDist (objects) (newClCenters)
  print newBelongingMatrix