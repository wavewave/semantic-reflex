{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Reflex.Dom.SemanticUI.Image where

import           Data.Default (Default (def))
import Data.Map (Map)
import qualified Data.Map as M
import           Data.Maybe (catMaybes)
import           Data.Semigroup ((<>))
import qualified Data.Set as S
import           Data.Text (Text)
import qualified Data.Text as T
import Data.Traversable (sequenceA)
import           Reflex
import           Reflex.Dom.Core hiding
  ( checkbox, Checkbox (..), checkbox_value, checkbox_change
  , CheckboxConfig (..), checkboxConfig_attributes, checkboxConfig_setValue
  )

import Reflex.Dom.SemanticUI.Common
import Reflex.Dom.SemanticUI.Header (Header)
import Reflex.Dom.SemanticUI.Transition

data ImageShape = Rounded | Circular | Avatar deriving (Eq, Show)

instance ToClassText ImageShape where
  toClassText Rounded = "rounded"
  toClassText Circular = "circular"
  toClassText Avatar = "avatar"

data Spaced = LeftSpaced | Spaced | RightSpaced deriving (Eq, Show)

instance ToClassText Spaced where
  toClassText LeftSpaced = "left spaced"
  toClassText Spaced = "spaced"
  toClassText RightSpaced = "right spaced"

data ImageConfig t = ImageConfig
  { _size :: Active t (Maybe Size)
  , _shape :: Active t (Maybe ImageShape)
  , _floated :: Active t (Maybe Floated)
  , _component :: Bool
  , _title :: Active t (Maybe Text)
  , _spaced :: Active t (Maybe Spaced)
  , _config :: ActiveElConfig t
  }

instance Reflex t => Default (ImageConfig t) where
  def = ImageConfig
    { _size = Static Nothing
    , _shape = Static Nothing
    , _floated = Static Nothing
    , _component = False
    , _title = Static Nothing
    , _spaced = Static Nothing
    , _config = def
    }

imageConfigClasses :: Reflex t => ImageConfig t -> Active t Classes
imageConfigClasses ImageConfig {..} = activeClasses
  [ Static $ justWhen (not _component) "ui image"
  , fmap toClassText <$> _size
  , fmap toClassText <$> _shape
  , fmap toClassText <$> _floated
  , fmap toClassText <$> _spaced
  ]

data Image t = Image
  { _src :: Active t Text
  , _config :: ImageConfig t
  }

data ContentImage t m a = ContentImage
  { _src :: Active t Text
  , _config :: ImageConfig t
  , _content :: Restrict Image m a
  }
