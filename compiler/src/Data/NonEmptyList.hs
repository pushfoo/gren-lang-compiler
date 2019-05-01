module Data.NonEmptyList
  ( List(..)
  , toList
  , sortBy
  )
  where


import qualified Data.List as List



-- LIST


data List a =
  List a [a]


toList :: List a -> [a]
toList (List x xs) =
  x:xs



-- INSTANCES


instance Functor List where
  fmap func (List x xs) = List (func x) (map func xs)


instance Traversable List where
  traverse func (List x xs) = List <$> func x <*> traverse func xs


instance Foldable List where
  foldr step state (List x xs) = step x (foldr step state xs)
  foldl step state (List x xs) = foldl step (step state x) xs
  foldl1 step      (List x xs) = foldl step x xs



-- SORT BY


sortBy :: (a -> a -> Ordering) -> List a -> List a
sortBy comparison (List x xs) =
  case List.sortBy comparison xs of
    [] ->
      List x []

    y:ys ->
      case comparison x y of
        LT -> List x (y:ys)
        EQ -> List x (y:ys)
        GT -> List y (List.insertBy comparison x ys)