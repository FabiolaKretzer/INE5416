module Resist (rst) where

x // y = do
-- extrai os  valores  de x e y:
	a <- x
	b <- y
		if b == 0 then
			Nothing  	
		else 
			Just (a / b)

soma x y = do
	x <- a
	y <- b
	return (a + b)

-- definiçãoao monádica  da  operação :

rst x y = let
	one = return 1
	rx = return x
	ry = return y
	in one // (add (one // rx) (one // ry))
