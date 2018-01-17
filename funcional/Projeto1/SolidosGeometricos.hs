--Fabíola Maria Kretzer

module Solidos (Solido(Esfera, Cilindro, Cone, TroncoCone, EsferoideObl, EsferoidePro),
		Raio, Altura, area, volume) where

data Solido = Esfera Raio
	| Cilindro Raio Altura
	| Cone Raio Altura
	| TroncoCone Raio Raio Altura
	| EsferoideObl Raio Raio
	| EsferoidePro Raio Raio
	deriving Show

type Raio = Float
type Altura = Float

ex :: Float -> Float -> Float
ex a b = sqrt(a^2 - b^2) / a

area :: Solido -> Float
area (Esfera r) = 4 * pi * r
area (Cilindro r h) =  2 * pi * r * h + 2 * pi * r^2
area (Cone r h) = pi * r * (sqrt(r^2 + h^2)) + pi * r^2
area (TroncoCone r1 r2 h) = pi * (r1 + r2) * (sqrt( h^2 + (r1 - r2)^2)) + pi * (r1 + r2)
area (EsferoideObl r1 r2) = 2 * pi * r1^2 + (r2^2 / (ex r1 r2)) * (log (1 + (ex r1 r2)) / (1 - (ex r1 r2)))
area (EsferoidePro r1 r2) = (2 * pi * r2^2) + (2 * pi * ((r1 * r2) / (ex r1 r2))) * (asin(ex r1 r2))
 
volume :: Solido -> Float
volume (Esfera r) = (4/3) * pi * r^3
volume (Cilindro r h) = pi * r^2 * h
volume (Cone r h) = (1/3) * pi * r^2 * h
volume (TroncoCone r1 r2 h) = (1/3) * pi * h * (r1^2 + r2^2 + r1 * r2)
volume (EsferoideObl r1 r2) = (4/3) * pi * r1^2 * r2
volume (EsferoidePro r1 r2) = (4/3) * pi * r1 * r2^2
