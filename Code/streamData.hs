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

streamEnd :: a
streamEnd = error "Theoratically Impossible"

naturals :: Stream Int
naturals = 0 ≺ (naturals + 1)
