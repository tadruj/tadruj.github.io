-- BUG: toDigits functions doesn't work with leading zeros 
-- Q:Create a list of digits for a number
toDigits :: Integral digit => digit -> [digit]
toDigits n
    | n <= 0 = []
    | otherwise = toDigits (n `div` 10) ++ [n `mod` 10]

-- Q:Reverse a list
reverse' :: [banana] -> [banana]
reverse' [] = []
reverse' (n:ns) = reverse' ns ++ [n]

-- Q:Double every other item on the list
doubleEveryOther' :: Integral digit => [digit] -> [digit]
doubleEveryOther' [] = []
doubleEveryOther' (n:[]) = [n] ++ []
doubleEveryOther' (n:ns:ms) = [n, ns * 2] ++ doubleEveryOther' ms

-- Q:Double every other item on the list backwards
doubleEveryOther :: Integral digit => [digit] -> [digit]
-- This is so COOL
doubleEveryOther = reverse' . doubleEveryOther' . reverse'

-- Q:Sum all numbers on the list
sum' :: Num digit => [digit] -> digit
sum' [] = 0 
sum' (n:ns) = n + (sum' ns)

-- Q:Sum digits in the list, double digits like 16 sum as 1 + 6 = 7
sumDigits :: Integral digit => [digit] -> digit
sumDigits [] = 0
sumDigits (n:ns) = (sum' (toDigits n)) + (sumDigits ns)

-- Validate by dividing the sum of doubled every other digits by 10 and checking for 0 remainder
validate :: Integral digit => digit -> Bool
validate n = (sumDigits (doubleEveryOther (toDigits n))) `mod` 10 == 0

