module Hiperbolico (FuncaoHiperbolica (Sinh, Cosh, Tanh, Coth), e, tmp) where

data FuncaoHiperbolica = Sinh Float
                        | Cosh Float 
                        | Tanh Float 
                        | Coth Float
                    deriving Show

e = 1 + sum([1 / product[1..x] | x <- take 1000 [1..]]) 

tmp :: FuncaoHiperbolica -> Float
tmp (Sinh x) = (1 - e**(-2*x))/(2*e**(-x))
tmp (Cosh x) = (1 + e**(-2*x))/(2*e**(-x))
tmp (Tanh x) = (tmp (Sinh x))/(tmp (Cosh x))
tmp (Coth x) = (tmp (Cosh x))/(tmp (Sinh x))