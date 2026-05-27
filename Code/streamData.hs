module StreamData where


data Stream a = Cons {streamHead::a, streamTail::Stream a}
    deriving Show

(≺) :: a -> Stream a -> Stream a
a ≺ s = Cons a s    


instance (Num a) => Num (Stream a) where    -- somehow, defines operators for streams
    (+) = zip (+)


streamEnd :: a
streamEnd = error "Theoratically Impossible"

naturals :: Stream Int
naturals = 0 ≺ (naturals + 1)
