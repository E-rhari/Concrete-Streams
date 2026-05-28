{- HLINT ignore "Redundant bracket" -}
module StreamData where


data Stream a = Cons {shead::a, stail::Stream a}
    deriving Show


infixr 5 ≺
(≺) :: a -> Stream a -> Stream a
a ≺ s = Cons a s    


instance Functor Stream where
    fmap f s = f (shead s) ≺ fmap f (stail s)

instance Applicative Stream where
    pure a = s where s = a ≺ s
    s <*> t = ((shead s) (shead t)) ≺ ((stail s) <*> (stail t))

-- "get" operator. Equivalent to !! in lists
(#) :: Stream a -> Int -> a
s # 0 = shead s
s # n = (stail s) # (n-1)

streamTake :: Int -> Stream a -> [a]
streamTake 0 s = [shead s]
streamTake n s = (shead s) : streamTake (n-1) (stail s)
