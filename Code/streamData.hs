data Stream a = Cons {streamHead::a, streamTail::Stream a}
    deriving Show

{- -- This is an equivalent way of defining the data structure, however
-- it does not create the streamHead and streamTail deconstructors by default.
data Stream a = Cons a (Stream a)
    deriving Show 
-}

(≺) :: a -> Stream a -> Stream a
a ≺ s = Cons a s

{- -- All Functions bellow do the same as streamHead <Stream> -- 
takeHead :: a -> Stream a
takeHead value = Cons {streamHead=value, streamTail=undefined}

takeHead :: Stream a -> a
takeHead stream = case stream of
    Cons h t -> h

takeHead2 :: Stream a -> a
takeHead2 (Cons h _) = h

takeHead3 :: Stream a -> a
takeHead3 s = streamHead s
-}

{- -- A thig for practicing instances
instance Functor (Stream a) where
    fmap :: (a -> b) -> Stream a -> Stream b
    fmap f s = undefined
-}


streamEnd :: a
streamEnd = error "Theoratically Impossible"

test :: Stream Int
test = Cons {streamHead=9, streamTail=streamEnd}

test2 = 8 ≺ test

main = print (streamHead test)