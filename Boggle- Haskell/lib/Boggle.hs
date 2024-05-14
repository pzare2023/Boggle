
module Boggle (boggle) where
import qualified Data.Set as Set
{--
    Fill in the boggle function below. Use as many helpers as you want.
    Test your code by running 'cabal test' from the tester_hs_simple directory.
--}


boggle :: [String] -> [String] -> [(String, [(Int, Int)])]
boggle board words = unique $ foldr (\word acc -> findWordPositions word ++ acc) [] words
  where
    findWordPositions word = map (\positions -> (word, positions)) (occ board word)


type Coordinate = (Int, Int)
type Board = [String]
type Path = [Coordinate]



unique :: (Ord a) => [(a, b)] -> [(a, b)]
unique xs = go Set.empty xs
  where
    go _ [] = []
    go seen ((a,b):xs)
      | a `Set.member` seen = go seen xs
      | otherwise = (a, b) : go (Set.insert a seen) xs



valid :: Board -> Coordinate -> Bool
valid board (row, col) = row >= 0 && col >= 0 && row < length board && col < length (head board)

occ :: Board -> String -> [[Coordinate]]
occ board word = do
    pos <- everything
    exploreBoard board word [] pos
  where
    everything = [(row, col) | row <- [0 .. r - 1], col <- [0 .. c - 1]]
    r = length board
    c = length (head board)


neighbour :: [Coordinate]
neighbour = [ (x, y) | x <- [-1..1], y <- [-1..1], abs x + abs y /= 0 ]


exploreBoard :: Board -> String -> Path -> Coordinate -> [[Coordinate]]
exploreBoard board word path start
    | not (validStart start) = []
    | isCompleteWord word = [[start]]
    | otherwise = extendPath board word path start
  where
    validStart coord = valid board coord && notElem coord path && startsWith board coord word



startsWith :: Board -> Coordinate -> String -> Bool
startsWith board (row, col) word = findChar board (row, col) == head word

findChar :: Board -> Coordinate -> Char
findChar board (row, col)
  | valid board (row, col) = (board !! row) !! col
  | otherwise = '\0'

isCompleteWord :: String -> Bool
isCompleteWord [_] = True
isCompleteWord _   = False

extendPath :: Board -> String -> [Coordinate] -> Coordinate -> [[Coordinate]]
extendPath board word path (row, col) =
    concatMap exploreNext neighbour
  where
    exploreNext (dx, dy) =
      let nextPos = (row + dx, col + dy)
      in map ((row, col) :) (exploreBoard board (tail word) ((row, col) : path) nextPos)

