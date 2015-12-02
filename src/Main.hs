import System.Random
import Data.Vector as V
import ArgumentParse as A
import RandomGenerator as R
import Options.Applicative as C
import CSVParser

main = do
  --The helper combinator takes any parser, and adds a help option to it.
  let args = info (helper <*> parseArgs) fullDesc
  parseArgs <- execParser args

  t <- readCsv (sourceFile parseArgs) ' '
  print t
  
  -- gen <- newStdGen 
  -- let value = R.getRandomDoubleMatrix 5 (clustersCount parseArgs) gen
  -- print value