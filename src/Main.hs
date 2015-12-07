import System.Random
import qualified Data.Vector as V
--import Data.List as L
import ArgumentParse as A
import RandomGenerator as R
import Options.Applicative as C
import CSVParser as P
import FCM
import Control.Exception

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
  
  gen <- newStdGen 
  
  --get objects from csv-file
  t <- try $ P.readCsv (sourceFile parseArgs) (delimiter parseArgs) :: IO (Either SomeException String)
  case t of 
    Left e -> putStrLn $ "Error: " ++ show e
    Right csvData -> do
      parseResult <- try $ parseCsv (convertCsvArgs parseArgs) t -- :: IO (Either SomeException (V.Vector (V.Vector Double)))
      case parseResult of
        Left e -> putStrLn $ "Error: " ++ show e
        Right objects -> do
          let result = FCM.fcmMain gen (clustersCount parseArgs) (precision parseArgs) objects (initialMatrix parseArgs) (metric parseArgs) 
          if (destFile parseArgs) == ""
            then
              Prelude.mapM_ (putStrLn . show) (result)
            else do
              let writeResultToFile = V.mapM_ (\x -> appendFile (destFile parseArgs) ((show x) ++ "\n")) result
              writingStatus <- try $ writeResultToFile :: IO (Either SomeException ())
              case writingStatus of
                Left e -> putStrLn $ "Error: " ++ show e
                Right _ -> putStrLn "Finished"
              
            