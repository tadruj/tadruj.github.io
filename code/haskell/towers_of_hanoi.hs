module Hanoi where
import Debug.Trace
-- Towers of Hanoi

type Peg = String
type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _ = []
hanoi n a b c = hanoi (n-1) a c b ++ [(a, b)] ++ hanoi (n-1) c b a

-- implementation with let  
hanoi' :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi' 0 _ _ _ = []
hanoi' n a b c = 
    let
        step1 = hanoi' (n-1) a c b
        step2 = [(a, b)]
        step3 = hanoi' (n-1) c b a
    in
        step1 ++ step2 ++ step3

-- implementation with let and guards
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

-- implementation with tracing
hanoi''' :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi''' n a b c
    | n == 0 = trace ("guard: n = 0") []
    | otherwise = 
        let
            step1 = trace ("step 1: " ++ show n ++ show a ++ show b ++ show c) $ hanoi''' (n-1) a c b
            step2 = trace ("step 2: " ++ show n ++ show a ++ show b ++ show c) $ [(a, b)]
            step3 = trace ("step 3: " ++ show n ++ show a ++ show b ++ show c) $ hanoi''' (n-1) c b a
        in
            step1 ++ step2 ++ step3
