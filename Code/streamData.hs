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
    s <*> t = ((shead s) (shead t)) ≺ ((stail s) <*> (stail t)) -- ??

instance (Num a) => Num (Stream a) where
    (+) = szip (+)
    (-) = szip (-)
    (*) = szip (*)
    abs = fmap abs
    signum = fmap signum
    negate = fmap negate
    fromInteger i = pure (fromInteger i)

-- "get" operator. Equivalent to !! in lists
(#) :: Stream a -> Int -> a
s # 0 = shead s
s # n = (stail s) # (n-1)


-- ---- Functions ----

szip :: (a -> b -> c) -> (Stream a -> Stream b -> Stream c)
szip f s t = pure f <*> s <*> t                                -- ??

-- "take" function. Equivalent to take for lists
stake :: Int -> Stream a -> [a]
stake 1 s = [shead s]
stake n s = (shead s) : stake (n-1) (stail s)
