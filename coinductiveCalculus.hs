import StreamData
import Data.Complex

-- Most of this code came from https://iagoleal.com/posts/calculus-symbolic-ode/#fnref3

type CalculusStream a = Stream a


derivate :: CalculusStream a -> CalculusStream a
derivate = stail

zero :: Num a => CalculusStream a
zero = 0 <: zero

identity :: Num a => CalculusStream a
identity = 0 <: 1 <: zero

-- -- My code doesn't perfectly work because we would need this, which spits out a Duplicate Instace error case we have already instatiated Stream as Num in streamData.hs
-- instance Num a => Num (CalculusStream a) where
--  -- Good ol' linearity
--  (-)  (Cons fa f')  (Cons ga g') = fa - ga <: f' - g'
--  (+)  (Cons fa f')  (Cons ga g') = fa + ga <: f' + g'
--  negate = fmap negate
--  -- Leibniz rule applied to CalculusStreams
--  (*) f@(Cons fa f') g@(Cons ga g') = fa * ga <: f' * g + f * g'
--  fromInteger n = fromInteger n <: zero
--  abs    = error "Absolute value is not a smooth funection"
--  signum = error "No well-defined sign for a series"

instance Fractional a => Fractional (CalculusStream a) where
 -- The division rule from Calculus. We assume g(0) ≠ 0
 (/) f@(Cons fa f') g@(Cons ga g') = fa / ga <: (f' * g - f * g') / g^2
 fromRational n = fromRational n <: zero


ex = 1 <: ex

sine = 0 <: cosine
    where cosine = 1 <: - sine
cosine = 1 <: -sine

sine'   = 0 <: 1 <: 0 <: -1 <: sine'
cosine' = 1 <: 0 <: -1 <: 0 <: cosine'

j = (0 :+ 1) <: j
enjx  = 1 <: (-j) * enjx
enjx' = (cosine - j*sine)