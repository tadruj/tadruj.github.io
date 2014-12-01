assert :: Bool -> a -> a
assert False x = error "assertion failed!"
assert _     x = x

test = assert (sumExample == 6) sumExample
     where sumExample = sum [1,2,3]

