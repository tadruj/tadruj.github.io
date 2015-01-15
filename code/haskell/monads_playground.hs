import Control.Monad
import Data.Functor
import Control.Applicative
import Control.Monad.Trans -- liftIO
import Text.Read
import Data.Maybe
import Control.Arrow
import System.Random
import Control.Monad.State

main =
		getLine >>= (readMaybe >>> (liftM sin) >>> return) >>= print
		--getLine >>= (readMaybe >>> return) >>= (liftM sin >>> return) >>= (fromJust >>> return) >>= print
		--getLine >>= return . readMaybe >>= return . (liftM sin) >>= print
		--getLine >>= (readMaybe >>> return) >>= (return . (liftM sin)) >>= print
		--getLine >>= return . (readMaybe :: String -> Maybe Float) >>= (return . (liftM sin)) >>= print
		--getLine >>= ((readMaybe :: String -> Maybe Float) >>= return . print . (liftM sin))
		--getLine >>= ((readMaybe :: String -> Maybe Float) >>= return . print)
		--getLine >>= (read >>> sin >>> print)
		--getLine >>= print . sin . (read :: String -> Float)

		-- getLine >>= print . sincos . read -- extract the output from the getLine IO monad
		-- (sin . read) <$> getLine -- this is a synonym for liftA
		-- liftM (sincos . read) getLine -- promote a sincosread to a monad
		-- liftA (sincos . read) getLine -- lift function to action
		-- print . sincos . read =<< getLine -- reverse extract the output from the IO monad
		-- getLine >>= print . sincos . read
		-- getLine >>= \s -> print $ sincos (read s) -- apply the output to the lambda to pull out the output from the IO monad

--So you write it as:
--do 
--	str1 <- getLine
--	str2 <- getLine
--	putStr (str1 ++ str2)
--or simply:
--	liftA2 (++) getLine getLine

--Reading two strings from the user and concatenating them would look like this:
--getLine >>= (\str1 ->
--	getLine >>= (\str2 ->
--		putStrLn (str1 ++ str2)))

-- main = do
--	let getLength :: IO Int
--		getLength = length <$> getLine
--	print =<< getLength
--	print =<< getLength

-- main = do
--	line <- fmap read getLine
--	print (sin line)

-- main = do
--	(number :: Float) <- (fmap read getLine :: IO Float)
--	print (number * number + 42)

-- (action :: IO Float) >>= (\(number :: Float) -> return (sin number))
--	    fmap sin action

-- <Iceland_jack>	Tantadruj: "liftIO" is just "id"
-- <Iceland_jack>	for IO
