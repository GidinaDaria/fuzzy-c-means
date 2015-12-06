import System.Random
import Data.Vector as V
import Data.List as L
import ArgumentParse as A
import RandomGenerator as R
import Options.Applicative as C
import CSVParser as P

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
  
  t <- P.readCsv (sourceFile parseArgs) (delimiter parseArgs)
  --print t
  let objects = parseCsv (convertCsvArgs parseArgs) t 
  print $ (objects)

  gen <- newStdGen 
  let value = R.getRandomMatrix gen 5 (clustersCount parseArgs)
  print value
  
  let centers = R.generateRandomCenters gen (clustersCount parseArgs) objects
  print centers