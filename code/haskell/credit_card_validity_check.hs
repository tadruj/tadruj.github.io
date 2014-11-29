-- BUG: toDigits functions doesn't work with leading zeros 
-- Q:Create a list of digits for a number
toDigits :: Integer -> [Integer]
toDigits n
    | n <= 0 = []
    | otherwise = toDigits (n `div` 10) ++ [n `mod` 10]

-- Q:Reverse a list
reverse' :: [Integer] -> [Integer]
reverse' [] = []
reverse' (n:ns) = reverse' ns ++ [n]

-- Q:Double every other item on the list
doubleEveryOther' :: [Integer] -> [Integer]
doubleEveryOther' [] = []
doubleEveryOther' (n:[]) = [n] ++ []
doubleEveryOther' (n:ns:ms) = [n, ns * 2] ++ doubleEveryOther' ms

-- Q:Double every other item on the list backwards
doubleEveryOther :: [Integer] -> [Integer]
-- This is so COOL
doubleEveryOther = reverse' . doubleEveryOther' . reverse'

-- Q:Sum all items on the list
sum' :: [Integer] -> Integer
sum' [] = 0 
sum' (n:ns) = n + (sum' ns)

-- Q:Sum digits in the list, double digits like 16 sum as 1 + 6 = 7
sumDigits :: [Integer] -> Integer
sumDigits [] = 0
sumDigits (n:ns) = (sum' (toDigits n)) + (sumDigits ns)

-- Validate by dividing the sum of doubled every other digits by 10 and checking for 0 remainder
validate :: Integer -> Bool
validate n = (sumDigits (doubleEveryOther (toDigits n))) `mod` 10 == 0

