module ArgumentParse
where
	
import Options.Applicative

data Args = Args  { 
                    sourceFile :: String,
                    clustersCount :: Int,
                    ignoringFirstRow :: FirstRow,
                    ignoringFirstCol :: FirstCol,
                    ignoringLastCol :: LastCol
                  }
                  
data FirstRow = FRIgnore | FRUse
data FirstCol = FCIgnore | FCUse
data LastCol = LCIgnore | LCUse

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
              <> metavar "COUNT"
              <> help "Set count of clusters" 
              <> value 2 
            )
            <*> flag FRIgnore FRUse
            ( 
              long "first row"
              <> short 'r'
              <> help "Enable ignoring the first row"
            )
            <*> flag FCIgnore FCUse
            ( 
              long "first column"
              <> short 't'
              <> help "Enable ignoring the first column" 
            )
            <*> flag LCIgnore LCUse
            ( long "last column"
              <> short 'y'
              <> help "Enable ignoring the last column" 
            )