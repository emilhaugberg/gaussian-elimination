module Data.Gaussian where

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception
import Control.Monad.Eff.Ref
import Data.Array (length, nub, nubBy)
import Data.Eq ((==))
import Data.Foldable (foldl)
import Data.Traversable (for)
import Prelude (bind, pure, join, not, ($), (&&), (>))

newtype Matrix = Matrix (Array (Array Number))

isSufficient :: Matrix -> Boolean
isSufficient (Matrix a) = 1 == length (nubBy (\xs ys -> length xs == length ys) a)

gaussImpl :: forall e. Array (Array Number) -> Eff (ref :: REF | e) (Array Number)
gaussImpl xs = do
  m  <- newRef xs
  m' <- readRef m
  pure $ join $ m'

gauss :: forall e. Matrix -> Eff (ref :: REF, err :: EXCEPTION | e) (Array Number)
gauss (Matrix m) = if not $ isSufficient (Matrix m)
  then throw "Matrix is not sufficient"
  else gaussImpl m
