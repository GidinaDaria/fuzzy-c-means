module CSVParser
where

import Data.CSV.Conduit as CND
--import Data.ByteString as BS
import Data.Text (Text)
import qualified Data.Vector as V
import qualified Data.ByteString as BS
import Data.List as L

data CSVSettings = CSVSettings  { 
                                  ignoringFirstRowCsv :: Bool,
                                  ignoringFirstColCsv :: Bool,
                                  ignoringLastColCsv :: Bool
                                }

csvset :: Char -> CND.CSVSettings 
csvset sep =  CND.CSVSettings {csvSep = sep, csvQuoteChar = Nothing}

readCsv :: String -> Char -> IO (V.Vector (Row String))
readCsv filePath delimiter = CND.readCSVFile (csvset delimiter) filePath

--filters 
filterCsv :: Bool -> Bool -> Bool -> V.Vector (Row String) -> V.Vector (Row String)
filterCsv ifr ifc ilc vl = (filterCsvFirstRow ifr (filterCsvFirstCol ifc (filterCsvLastCol ilc vl)))

filterCsvFirstRow :: Bool -> V.Vector (Row String) -> V.Vector (Row String)
filterCsvFirstRow ifr vl = if ifr then V.tail(vl) else vl

filterCsvFirstCol :: Bool -> V.Vector (Row String) -> V.Vector (Row String)
filterCsvFirstCol ifc vl = if ifc then V.map (\x -> L.tail(x)) vl else vl

filterCsvLastCol :: Bool -> V.Vector (Row String) -> V.Vector (Row String)
filterCsvLastCol ilc vl = if ilc then V.map (\x -> L.init(x)) vl else vl

--convert to double
decodeCsv :: V.Vector (Row String) -> V.Vector (V.Vector Double)
decodeCsv a = V.map (\y -> V.fromList(L.map (\x -> (read(x)::Double)) y)) a 

parseCsv :: CSVParser.CSVSettings -> V.Vector (Row String) -> V.Vector (V.Vector Double)
parseCsv settings vl = decodeCsv (filterCsv (ignoringFirstRowCsv settings) (ignoringFirstColCsv settings) (ignoringLastColCsv settings) vl)

