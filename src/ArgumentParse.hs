module ArgumentParse
where

import Options.Applicative

data Args = Args  { 
                    sourceFile :: String,
                    clustersCount :: Int,
                    precision :: Double,
                    delimiter :: Char,
                    ignoringFirstRow :: Bool,
                    ignoringFirstCol :: Bool,
                    ignoringLastCol :: Bool
                  } deriving (Show)

parseArgs :: Parser Args
parseArgs = Args
            <$> argument str 
            ( 
              metavar "FILE" 
              <> help "File with data" 
              <> value "butterfly.txt"
            ) 
            <*> option auto
            ( 
              long "cluster"
              <> short 'c'
              <> metavar "INT"
              <> help "Set count of clusters" 
              <> value 2 
            )
            <*> option auto
            (
              long "precision"
              <> short 'p'
              <> metavar "DOUBLE"
              <> help "Set precision of FCM-algorithm"
              <> value 0.01
            )
            <*> option auto
            (
              long "delimiter"
              <> short 'd'
              <> metavar "CHAR"
              <> help "Det delimiter for CSV-file parsing"
              <> value ','
            )
            <*> flag False True
            ( 
              long "ignorefr"
              <> short 'u'
              <> help "To ignore the first row use this flag. Default is not ignore"
            )
            <*> flag False True
            ( 
              long "ignorefc"
              <> short 'i'
              <> help "To ignore the first column use this flag. Default is not ignore" 
            )
            <*> flag True False
            ( long "ignorelc"
              <> short 'o'
              <> help "To not ignore the last column use this flag. Default is ignore" 
            )