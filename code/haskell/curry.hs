-- Currying 
baz :: Int -> Int -> Int
baz x y = x * y

-- The same function, but this time the y
-- is replaced by a anonymous function
bar x = \y -> x * y

-- So, if we supply arguments to the function.
-- Having an x of 2.
bar 2 = \y -> 2 + y

-- And an y of 3.
-- Returns a value of 5
bar 2 = (\y -> 2 + y) 3
