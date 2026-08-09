import StreamData

-- Most of this code came from https://iagoleal.com/posts/calculus-symbolic-ode/#fnref3


derivate :: Stream a -> Stream a
derivate = stail

zero :: Num a => Stream a
zero = 0 <: zero

identity :: Num a => Stream a
identity = 0 <: 1 <: zero


euler = 1 <: euler
sine = 0 <: cosine
    where cosine = 1 <: - sine
sine' = 0 <: 1 <: 0 <: -1 <: sine'


-- eval :: Fractional a => a -> Stream a -> a -> a
-- eval a f x = foldr1 (\ fa f' -> fa + (x - a) * f') (take 100 taylor)
--     where
--         taylor = zipWith (/) (toList f) factorials
--         factorials = let fats = 1 : zipWith (*) fats [1..] in fmap fromIntegral fats