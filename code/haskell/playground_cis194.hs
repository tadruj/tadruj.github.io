x :: Int
x = 3

y :: Int
y = y + 1

reallyBig :: Integer
reallyBig = 2^(2^(2^(2^2)))

reallyBigLength = length (show reallyBig)

i :: Int
i = 30

j :: Int
j = 5

-- Q:Explicitly define two Integrals and then type-cast them to do a floating-point division
k = i `div` j
-- No floating-point division between Integrals
-- l = i / j
-- Must be explicitly converted to Num
l = fromIntegral(i) / fromIntegral(j)

-- Q:Write a sumtorial function which returns sum of numbers up to n using pattern matching
sumtorial :: Integer -> Integer
sumtorial 0 = 0
sumtorial x = x + sumtorial (x - 1)
m = sumtorial 4

-- Q:Write a sumtorial function which returns sum of numbers up to n using guards
sumtorialG :: Integer -> Integer
sumtorialG x
    | x == 0 = 0
    | otherwise = sumtorialG x
n = sumtorial 4

f :: Int -> Int -> Int -> Int
f x y z = x + y + z

g = f 17 3 33
h = 4
-- wrong because function application has precedence than infix operators 
-- q = f 17 h-1 33
-- right
r = f 17 (h-1) 33

-- Singly linked lists - take empty list and prepend numbers one by one
lst = 1:2:3:4:[]

hailstone :: Integer -> Integer
hailstone n
    | n `mod` 2 == 0 = n `div` 2
    | otherwise = 3 * n + 1

hailstoneSeq :: Integer -> [Integer]
hailstoneSeq 1 = [1]
hailstoneSeq n = n : hailstoneSeq (hailstone n)

-- Q:Write a function that calculates list length
listLength :: [Integer] -> Integer
listLength [] = 0
listLength (x:xs) = 1 + listLength xs

aLen = listLength [1,2,3,4,5] 



