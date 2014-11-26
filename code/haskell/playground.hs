-- Function and name definitions

doubleSumUs x y = doubleMe x + doubleMe y -- use other functions, even if defined after

doubleMe x = x+x -- name of the function begins with small caps

doubleCondMe x = if x < 100 -- else is mandatory
	then x+x
	else x

doubleCondUs x y = if x < 100 && y < 100 then 2*x+2*y else x+y -- if is an expression

janeO'Barrel = "Surfer" -- no args = definition or a name

-- List composition
-- Lists contain only same type

stringOfChars = ['A','p','p','l','e']
stringAtOnce = "Orange"

shoppingList = stringOfChars ++ " " ++ stringAtOnce

aShoppingList = 'a':shoppingList

numList = [1,2,3]
numListSlow = [1] ++ numList -- takes two lists
numListQuick = 1:numList -- quick: takes a number and a list

numListTheDirtyWay = 1:2:3:4:[] -- add numbers to the empty list [1,2,3] is just a shorthand

theMatrix = [4]:[3:[],2:1:[],[]] -- add elements to the list

zeMatrix = theMatrix !! 2 !! 1 -- select elements from list

-- List operations

listHead = head [1,2,3,4] -- [1]
listTail = tail [1,2,3,4] -- [2,3,4]
lastInTheList = last [1,2,3,4] -- [4]
allExceptLast = init [1,2,3,4] -- [1,2,3]

lengthOfList = length [1,2,3,4] -- 4
listIsEmpty = null [] -- True

reversedList = reverse [1,2,3,4] -- [4,3,2,1]
chopFirstTwoElements = take 2 [1,2,3,4] -- [1,2]

dropFirstTwoElements = drop 2 [1,2,3,4] -- [3,4]

-- Q:Find a minimum and maximum number in the array
maxElement = maximum [1,2,3,4] -- [4]
minElement = minimum [1,2,3,4] -- [1]

sumOfElements = sum [1,2,3,4] -- 10
productOfElements = product [1,2,3,4] -- 24

elementIsOnList = elem 3 [1,2,3,4] -- True -- is_on_list
elementIsOnListInfix = 5 `elem` [1,2,3,4] -- False -- infix notation

-- Ranges

listFromOneToTwenty = [1..20]
listFromKToQ = ['k'..'q']
listFromOneToTwentyEveryThree = [1,4..20]
listBackwards = [20,19..1]

-- Q:Find first 9 numbers of a sequence starting with 60 and increasing every 13
firstNineOfAWeirdInfiniteSequence = take 9 [0,22/7..] -- cool, this stuff finally got interesting
cyclingSequences = take 13 (cycle (' ':['L','O','L']))
repeatOneElementAndChopTenOfThem = take 10 (repeat 5)
repeatOneElementTenTimes = replicate 10 5

-- List comprehensions

evenNumbers = [x*2 | x <- [1..10]]
evenNumbersSmallerThan15 = [x*2 | x <- [1..10], x*2 < 15]
-- Q:Calculate squares of first ten numbers that return 4 on modulo 7
sequenceOfDoublesWhereModuloReturnsThree = [x*2 | x <- [50..100], x `mod` 7 == 3]

nameOddity x = [if odd x then "ODD" else "EVEN"]
showOddity = [nameOddity x|x <- [1..10]]

-- Q:Return BIG for every number in a sequence devisible by 5 and BANG for every divisible by 3
squencExcludingSomeNumbers = [ x | x <- [10..20], x /= 13, x /= 15, x /= 19] -- many predicates

-- Q:Write FIZZ BUZZ as a list comprehension
fizzBuzz = [if x `mod` 15 == 0 then "FIZZBUZZ" else if x `mod` 3 == 0 then "FIZZ" else if x `mod` 5 == 0 then "BUZZ" else show x|x <- [1..100]]

allCombinationsOfThreeArrays = [[x,y,z]|x <- [1,2,3], y <- [4,5,6], z <- [7,8,9]] -- combinations

-- Q:Write combinations of nouns and adjectives
familyNames = ["Rok","Ana","Mama","Ata"]
familyQualities = ["big","good","master","dear"]
noAdj = [y ++ " " ++ x | x <- familyNames, y <- familyQualities]

-- Q:Implement length' function
length' x = sum [1 | _ <- x]

-- Q:Remove all lowercase letters from a string
leaveCapsOnly s = [x | x <- s, x `elem` ['A'..'Z']]

-- Q:Remove odd numbers without flattening the list of lists of numbers [[1,2,3,4,5],[6,7,8]]
noOdsNoFlatten = [ [ x | x <- row, even x ] | row <- [[1,2,3,4,5],[6,7,8]]]

-- Tuples

myFamily = [("mama",50),("ana",20),("rok",33)]
myMamaName = fst (head myFamily)
myRokAge = snd (last myFamily) 

-- Q:Add together two arrays into array of tuples
zippedTuples = zip [1 .. 5] ["one", "two", "three", "four", "five"]

-- nice example of lazy evaluation - working with infinite arrays
zippingTwoArraysIntoArrayOfTuples = zip [1..] ["apple", "orange", "cherry", "mango"]

-- Types

-- explicityly or implicitly telling the type the read must return

-- Q:Create list of numbers from a string
implicitArrayFromString = read "[1,2,3]" ++ [4] -- implicit - needs a number to have and idea for Int inside of [Int]
explicitArrayFromString = (read "[1,2,3,4]") :: [Int] -- explicit - needs parents
explicitTupleFromString = read "(3, 'a')" :: (Int, Char)

myHugeInteger = 20 :: Integer
mySmallerInteger = 20 :: Int
mySinglePrecision = 20 :: Float
myDoublePrecision = 20 :: Double
myBool = True :: Bool
myChar = 'a' :: Char

-- Typeclasses
--
-- Eq - Equality - supports == and /=
-- Ord - Ordering - supports > >= < <=
-- Show - can be presented as String
-- Read - can be read from String but needs to explicit type annotation -- see [ie].*ArrayFromString
-- Enum - Sequentially ordered - has succ and pred functions - (), Bool, Char, Ordering, Int, Integer, Float and Double
-- Bounded - Upper and lower limit minBound :: Int, maxBound :: Int
-- Num - Numeric - act like numbers (must also have properties of Eq and Show)
-- Integral - whole numbers
-- Floating - Double and Float

-- Pattern Matching

-- Q:Create a function which adds vectors
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)  
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- NOTE: I guess the pattern matching is used mostly for destructuring

matchHead (x:_) = x
matchTail (_:x) = x
matchTwo (x:y:[]) = (x,y)
matchTwoOrMore (x:y:_) = (x,y)

-- stringLength :: (Num b) => [a] -> b
stringLength [] = 0
stringLength (_:tail) = 1 + length tail

-- Guards

-- NOTE: Use guards for checking values and do conditions


