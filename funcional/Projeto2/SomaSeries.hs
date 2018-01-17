--Fabíola Maria Kretzer

module SomaSeries where

somaInt n = map (\x-> (x * (x+1) / 2)) [1..n]
totalLista n = last (somaInt n)

somaImpar n = map(\x -> sum [1,3..x])  [1,3..n]
totalSomaImpar n = last(somaImpar n)

somaPar n = map(\x -> sum [2,4..x]) [2,4..n]
totalSomaPar n = last(somaPar n)

somaQuadrados n = map(\x -> sum [y**2 | y <- [0..x]]) [0..n]
totalSomaQuadrados n = last(somaQuadrados n)

somaQuadradosImpares n = map(\x -> sum [y**2 | y <- [1,3..x]]) [1,3..n]
totalSomaQuadradosImpares n = last(somaQuadradosImpares n)

quaseDois n = sum(map(\x -> 2 / (x * x + x)) (take n [1..]))

quaseEuler n = 1 + sum(map(\x -> 1 / product[1..x]) (take n [1..]))
