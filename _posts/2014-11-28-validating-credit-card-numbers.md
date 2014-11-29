---
layout: post
title: Pattern matching, guards and function composition - Validating credit card numbers 
lang: haskell
tags: haskell
---

### Validating credit card numbers

Credit card validation algorithm goes like this:

- double the value of every second digit from the right
- sum the digits of the doubled and undoubled values
- any doubled digits over 9 are split and sumed as seperate numbers 
- calculate the remainder of the sum divided by 10
- if the reminder is 0 the number is valid

Algorithm is implemented in Haskell including `reverse'` and `sum'` functions, which are usually provided by the basic Haskell libraries.

I use guards in `toDigits` function to branch the function.<br />
In other functions I mostly use pattern matching, because I need to destructure the lists to recurse over them.<br />
Function composition is demonstrated in `doubleEveryOther`.

{% highlight haskell %}

-- transform long card integral number to a list of digits
toDigits :: Integral digit => digit -> [digit]
toDigits n
    | n <= 0 = []
    | otherwise = toDigits (n `div` 10) ++ [n `mod` 10]

-- reverse a list
reverse' :: [banana] -> [banana]
reverse' [] = []
reverse' (n:ns) = reverse' ns ++ [n]

-- double every other digit on the list
doubleEveryOther' :: Integral digit => [digit] -> [digit]
doubleEveryOther' [] = []
doubleEveryOther' (n:[]) = [n] ++ []
doubleEveryOther' (n:ns:ms) = [n, ns * 2] ++ doubleEveryOther' ms

-- since we need to double every other digit from the back we compose the functions
-- reverse the list, double every other digit and then reverse back
doubleEveryOther :: Integral digit => [digit] -> [digit]
doubleEveryOther = reverse' . doubleEveryOther' . reverse'

-- sum the numbers on the list
sum' :: Num digit => [digit] -> digit
sum' [] = 0 
sum' (n:ns) = n + (sum' ns)

-- sum the digits on the list ( double digits like 16 sum as 1 + 6 = 7 )
sumDigits :: Integral digit => [digit] -> digit
sumDigits [] = 0
sumDigits (n:ns) = (sum' (toDigits n)) + (sumDigits ns)

-- validate
validate :: Integral digit => digit -> Bool
validate n = (sumDigits (doubleEveryOther (toDigits n))) `mod` 10 == 0

{% endhighlight %}

