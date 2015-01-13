import Control.Monad
import Data.Functor
import Control.Applicative
import Control.Monad.Trans -- liftIO

main :: IO ()
main = do
      putStrLn "Put in a number (even a float) and hit enter:"
      inpt <- getLine
      let number = (read inpt :: Float)
          sincos = sin.cos in
              putStrLn $ show (sincos number)
