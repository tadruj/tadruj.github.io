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

-- New Data Types
-- BookInfo is a type constructor
-- Book is a value constructor
-- They can have the same name, depending on signature/expression context we know what we're using
data ItemInfo = Book Int String [String] 
              | Magazine Int String [String] 
              deriving (Show)

myBook = Book 0 "Rok is functional" ["Rok F", "Rok K"]
myMagazine = Magazine 1 "Rok is funkcionar" ["Rok K", "Rok F"]

-- Type synonyms - used for readability of code
type PID = Int
type Name = String

-- Q:Construct an algebraic data type for Polar2D and Cartesian2D
-- x and y coordinates or lengths.
data Cartesian2D = Cartesian2D Double Double
                   deriving (Eq, Show)

-- Angle and distance (magnitude).
data Polar2D = Polar2D Double Double
               deriving (Eq, Show)

data Roygbiv = Red
             | Orange
             | Yellow
             | Green
             | Blue
             | Indigo
             | Violet
               deriving (Eq, Show)

sameColors = Green == Green
differentColors = Yellow == Orange

-- Pattern Matching

myNot True  = False
myNot False = True

whatIsThis (Book num title authors) = "Book"
whatIsThis (Magazine num title authors) = "Mag"
whatIsTitle (Book _ title _) = title
whatIsTitle (Magazine _ title _) = title
publicationType = whatIsThis myBook

-- Record Syntax

data Shape = 
    Circle {
        shapeName :: String,
        circleRadius :: Int
        }
    |
    Square {
        shapeName :: String,
        shapeSide :: Int
        }
    deriving (Show)

myCircle = Circle "Gran'ole'Circle" 3
mySquare = Square "Times Square" 4

myCircleName = shapeName myCircle
mySquareName = shapeName mySquare

shapeArea :: Shape -> Float
shapeArea (Circle _ r) = pi * (fromInteger (toInteger r)) ** 2
shapeArea (Square _ a) = (fromInteger (toInteger a)) ** 2

-- Patameterised types

-- data Maybe a = Just a
--             | Nothing

someBool = Just True
someString = Just "something"

-- non-homogeneous list implementation
data ThisOrThat = TString String
                | TBool Bool
                deriving (Show)

namez = (TBool False):(TString "Rok"):[] :: [ThisOrThat]



