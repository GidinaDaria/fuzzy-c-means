import System.Random
import Data.Vector as V
import ArgumentParse as A
import RandomGenerator as R
-- import System.Environment as E


main = do
  -- args <- getArgs
  -- Prelude.mapM putStrLn (A.getSize args)
  gen <- newStdGen
  let value = R.getRandomDoubleMatrix 5 5 gen
  print value