import System.Random
import qualified Data.Vector as V
import ArgumentParse as A
import Options.Applicative
import CSVParser as P
import FCM
import Control.Exception
import Data.CSV.Conduit (Row)

convertCsvArgs :: A.Args -> P.CSVSettings
convertCsvArgs args = P.CSVSettings {  
                                      ignoringFirstRowCsv = (ignoringFirstRow args),
                                      ignoringFirstColCsv = (ignoringFirstCol args),
                                      ignoringLastColCsv = (ignoringLastCol args)
                                    }
                                    
main = do
  --parsing arguments
  let args = info (helper <*> parseArgs) fullDesc
  parseArgs <- execParser args
  print parseArgs
  
  gen <- newStdGen 
  
  --get objects from csv-file
  t <- try $ P.readCsv (sourceFile parseArgs) (delimiter parseArgs) :: IO (Either SomeException (V.Vector (Row String)))
  case t of 
    Left e -> putStrLn $ "Error during reading csv file: " ++ show e
    Right csvData -> do
    
      --filter csvData
      parseResult <- try $ parseCsv (convertCsvArgs parseArgs) csvData :: IO (Either SomeException (V.Vector (V.Vector Double)))
      case parseResult of
        Left e -> putStrLn $ "Error during filtering data from csv: " ++ show e
        Right objects -> do
        
          let result = FCM.fcmMain gen (clustersCount parseArgs) (precision parseArgs) objects (initialMatrix parseArgs) (metric parseArgs) 
          if (destFile parseArgs) == ""
            then
              
              Prelude.mapM_ (putStrLn . show) (result)
            else do
              let writeResultToFile = V.mapM_ (\x -> appendFile (destFile parseArgs) ((show x) ++ "\n")) result
              writingStatus <- try $ writeResultToFile :: IO (Either SomeException ())
              case writingStatus of
                Left e -> putStrLn $ "Error during writing results of clusterization: " ++ show e
                Right _ -> putStrLn "Finished"
              
            