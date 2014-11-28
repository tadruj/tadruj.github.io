-- every function has only one parameter
a x = x + 3
b = a 4

-- if it has two, it gets partially executed with first parameter
-- returns partially applied function
-- which gets executed with second parameter
f x y = x + y
g = f 3
h = g 4
i = (f 4) 3

-- f is basically a sum of two numbers function which is already available under name +
j = (+ 4) 3

-- if something is a function, it expects an argument on the right
-- + takes 4 returns f
-- f takes 3 returns 7
-- + takes 7 returns f
-- f takes 2 returns 9
k = (+ ((+ 4) 3)) 2

-- OMG, Haskell is not really a LISP, it's a giant Lambda machine
l = (+ (+ 4) 3 ) 3 
-- I'm going home
