---
layout: post
title: Demonstrating function readability with let - Towers of Hanoi 
lang: haskell
tags: haskell
---

### Towers of Hanoi

The recursive algorithm for solving the problem goes like this:

1. move n − 1 discs from a to c using b as temporary storage
2. move the top disc from a to b
3. move n − 1 discs from c to b using a as temporary storage.

Algorithm is implemented in Haskell.
I decomposed a function into identifiable steps for improved readability and comprehension

{% highlight haskell %}

type Peg = String
type Move = (Peg, Peg)

hanoi'' :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi'' n a b c
    | n == 0 = []
    | otherwise =
        let
            step1 = hanoi'' (n-1) a c b
            step2 = [(a, b)]
            step3 = hanoi'' (n-1) c b a
        in
            step1 ++ step2 ++ step3

{% endhighlight %}

