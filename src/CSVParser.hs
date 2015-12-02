module CSVParser
where

import Data.CSV.Conduit

import Data.Text (Text)
import qualified Data.Vector as V
import qualified Data.ByteString as B

csvset :: Char ->  CSVSettings 
csvset c =  CSVSettings {csvSep  = ',', csvQuoteChar = Just '"'}

readCsv :: String -> Char -> IO (V.Vector (Row Text))
readCsv fp del = readCSVFile (csvset del) fp