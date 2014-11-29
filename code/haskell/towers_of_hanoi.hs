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

