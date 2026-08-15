module StreamData where

{- HLINT ignore "Redundant bracket" -}

{- This code implements common haskell functions for Streams. Although it bothers me a litle,
   it seems to be common practice in haskell to name such functions using the original function's
   name preceded by the first letter of the type. That is, as 'map' becomes 'fmap' for Functors,
   'take' and such become 'stake' and ssuch for Streams, despite the latter's meaning in english -}


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


-- ---- Operators ----

-- synonym for Cons so we can code it the same way we would write it
(≺) :: a -> Stream a -> Stream a
a ≺ s = Cons a s
infixr 5 ≺

-- synonym for ≺ because it's quite a drag to copypaste it
(<:) :: a -> Stream a -> Stream a 
a <: s = a ≺ s
infixr 5 <:

-- interleaves two streams
(⋎) :: Stream a -> Stream a -> Stream a
s ⋎ t = shead s ≺ t ⋎ stail s
infixr 5 ⋎

-- synonym for ⋎
(\/) :: Stream a -> Stream a -> Stream a
s \/ t = s ⋎ t
infixr 5 \/


-- "get" operator. Equivalent to !! for lists. 
(#) :: Stream a -> Int -> a
s # 0 = shead s
s # n = (stail s) # (n-1)

-- equality operator. Can't overload it by instaciating Eq cause (==) returns Bool, not Stream Bool
(#==) :: (Applicative i, Eq a) => i a -> i a -> i Bool
(#==) = szip (==)
infix 4 #==

(#/=) :: (Applicative i, Eq a) => i a -> i a -> i Bool
(#/=) = szip (/=)


-- ---- Functions ----

szip :: (Applicative i) => (a -> b -> c) -> (i a -> i b -> i c)
szip f s t = pure f <*> s <*> t 

-- "take" function. Equivalent to take for lists
stake :: Int -> Stream a -> [a]
stake 1 s = [shead s]
stake n s = (shead s) : stake (n-1) (stail s)

-- "get" function. Equivalent to the # operator defined above but made to look similar to Hinze's article
slookup :: Stream a -> Int -> a
slookup s n = s # n

-- returns a list with the first 10 elements of the Stream
ssample :: Stream a -> [a]
ssample s = stake 10 s

-- generalization of the ⋎ operator for many streams
interleave :: [Stream a] -> Stream a
interleave (s:x) = shead s <: interleave(x ++ [stail s])

-- turns a function into a stream
stabulate :: (Int -> a) -> Stream a
stabulate f = f 0 ≺ stabulate (f . (+1))

-- creates a stream by recursing a function starting at a given seed
srecurse :: (a -> a) -> a -> Stream a
srecurse f a = s where s = a ≺ fmap f s

-- creates a stream by repeatedly applying a given function to a given initial seed
siterate :: (a -> a) -> a -> Stream a
siterate f a = a ≺ siterate f (f a)

--
sunfold :: (s -> a) -> (s -> s) -> (s -> Stream a)
sunfold g f a = g a ≺ sunfold g f (f a)  


-- ---- Streams ----

nat = 0 ≺ nat + 1
fac = 1 ≺ (nat+1)*fac
fib = 0 ≺ fib' where fib' = 1 ≺ fib + fib'

strue = pure True :: Stream Bool
sfalse = pure False :: Stream Bool
truefalse = True ≺ fmap not truefalse

plusneg = 1 ⋎ -1
natdiv2 = nat ⋎ nat
natmod2 = 0 ⋎ 1


-- ---- Interleave Alternatives ----

-- Equal to nat
bin = 0 ≺ 2*bin+1 ⋎ 2*bin+2 -- despite its name, bin is not the sequence of naturals in binary, but the regular naturals constructed through the idea of binary numbers

seven = 0 ≺ seven+2
sodd = 1 ≺ sodd+2
evenodd = seven ⋎ sodd

-- Equal to truefalse
truefalse' = True ≺ pure False ⋎ pure True