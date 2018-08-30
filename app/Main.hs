module Main where

import Lib
import ParallelConduit
import qualified Data.Conduit.List as CL
import           Data.Conduit

-- For the example `main`
import           Control.Concurrent (threadDelay)
import qualified Data.ByteString.Char8 as BS8
import qualified Data.Conduit.List as CL
import           Say (sayString)
import           Control.Monad.IO.Class

-- main :: IO ()
-- main = someFunc

-- Example usage
main :: IO ()
main = do

  l <- runConduitRes $
       CL.sourceList [1..6]
    .| conduitPooledMapMBuffered 4 (\i -> liftIO $ do
                                      sayString (show i ++ " before")
                                      threadDelay (i * 1000000)
                                      sayString (show i ++ " after")
                                      return (i*2)
                                   )
    .| CL.consume

  sayString ("Result: " ++ show l)
