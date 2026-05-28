module StreamData where

{- HLINT ignore "Redundant bracket" -}

{- This code implements common haskell functions for Streams. Although it bothers me a litle,
   it seems to be common practice in haskell to name such functions using the original function's
   name preceded by the first letter of the type. That is, as 'map' becomes 'fmap' for functors,
   'take' and such become 'stake' and ssuch for Streams, despite the word's meaning in english -}


-- ---- Definition ----

data Stream a = Cons {shead::a, stail::Stream a}

instance (Show a) => Show (Stream a) where
    show s = show (shead s) ++ ", " ++ show (stail s) -- runs forever and you really should use stake instead

instance Functor Stream where
    fmap f s = (f (shead s)) ≺ fmap f (stail s)

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


-- ---- Operations ----

-- synonym for Cons so we can code it the same way we would write it
infixr 5 ≺
(≺) :: a -> Stream a -> Stream a
a ≺ s = Cons a s

-- synonym for ≺ because it's quite a drag to copypaste it
infix 5 <:
(<:) :: a -> Stream a -> Stream a 
a <: s = a ≺ s

-- "get" operator. Equivalent to !! for lists
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
