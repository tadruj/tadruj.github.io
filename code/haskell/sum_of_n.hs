-- Sum of 'n' Numbers
--
-- sum_of_n (or SequenceSum.sumOfN in Java) takes an integer n and returns a List of length abs(n) + 1. The List contains the numbers in the arithmetic series produced by taking the sum of the consecutive integer numbers from 0 to n inclusive.
--
-- n can also be 0 or a negative value.
-- Example:
--
-- 5 -> [0, 1, 3, 6, 10, 15]
--
-- 7 -> [0, 1, 3, 6, 10, 15, 21, 28]
-- (-7) -> [-0, -1, -3, -6, -10, -15, -21, -28]

sumOfN :: Int -> [Int]
sumOfN 0 = [0]
sumOfN n =
        let
            oper n = if n < 0 then (-1) else (1)
        in
            (sumOfN (n - (oper n))) ++ [(sum [0..(abs n)]) * (oper n)]

main = putStrLn (show (sumOfN 7))

