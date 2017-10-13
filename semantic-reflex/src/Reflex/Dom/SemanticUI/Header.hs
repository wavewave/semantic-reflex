{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Reflex.Dom.SemanticUI.Header where

import Data.Foldable (traverse_)
import Control.Lens
import Data.Default (Default (def))
import Data.Map (Map)
import qualified Data.Map as M
import Data.Maybe (catMaybes)
import Data.Semigroup ((<>))
import Data.String
import Data.Text (Text)
import qualified Data.Text as T
import Reflex
import Reflex.Dom.Core hiding
  ( checkbox, Checkbox (..), checkbox_value, checkbox_change
  , CheckboxConfig (..), checkboxConfig_attributes, checkboxConfig_setValue
  )

import Reflex.Dom.SemanticUI.Common
import Reflex.Dom.SemanticUI.Divider (Divider)
import Reflex.Dom.SemanticUI.Transition hiding (divClass)

data HeaderPreContent

data HeaderConfig t = HeaderConfig
  { _iconHeader   :: Active t Bool
  , _dividing     :: Active t Bool
  , _sub          :: Active t Bool
  , _disabled     :: Active t Bool
  , _block        :: Active t Bool
  , _inverted     :: Active t Bool

  , _size         :: Active t (Maybe HeaderSize)
  , _floated      :: Active t (Maybe Floated)
  , _aligned      :: Active t (Maybe Aligned)
  , _color        :: Active t (Maybe Color)
  , _attached     :: Active t (Maybe VerticalAttached)

  , _component    :: Bool -- This controls the "ui" class
  , _item         :: Bool
  , _config       :: ActiveElConfig t
  }

instance Default (HeaderConfig t) where
  def = HeaderConfig
    { _iconHeader = Static False
    , _dividing = Static False
    , _sub = Static False
    , _disabled = Static False
    , _block = Static False
    , _inverted = Static False

    , _size = Static Nothing
    , _floated = Static Nothing
    , _aligned = Static Nothing
    , _color = Static Nothing
    , _attached = Static Nothing

    , _component = True
    , _item = False
    , _config = def
    }

headerConfigClasses :: Reflex t => HeaderConfig t -> Active t Classes
headerConfigClasses HeaderConfig {..} = activeClasses
  [ Static $ Just "header"
  , boolClass "icon" _iconHeader
  , boolClass "dividing" _dividing
  , boolClass "sub" _sub
  , boolClass "disabled" _disabled
  , boolClass "block" _block
  , boolClass "inverted" _inverted

  , fmap toClassText <$> _floated
  , fmap toClassText <$> _aligned
  , fmap toClassText <$> _color
  , fmap toClassText <$> _attached

  , boolClass "ui" $ Static _component
  , boolClass "item" $ Static _item
  ]

data HeaderSize = H1 | H2 | H3 | H4 | H5 deriving (Eq, Show)

headerSizeEl :: HeaderSize -> Text
headerSizeEl H1 = "h1"
headerSizeEl H2 = "h2"
headerSizeEl H3 = "h3"
headerSizeEl H4 = "h4"
headerSizeEl H5 = "h5"

-- | We can't use 'Size' because the content header css only implements these 5
-- specific sizes.
headerSizeText :: HeaderSize -> Text
headerSizeText H1 = "huge"
headerSizeText H2 = "large"
headerSizeText H3 = "medium"
headerSizeText H4 = "small"
headerSizeText H5 = "tiny"

-- | Create a header.
--
-- https://semantic-ui.com/elements/header.html
data PageHeader t m a = PageHeader
  { _size :: HeaderSize
  , _config :: HeaderConfig t
  , _content :: Restrict Header m a
  }

data ContentHeader t m a = ContentHeader
  { _config :: HeaderConfig t
  , _content :: Restrict Header m a
  }

data Content t m a = Content
  { _config :: ActiveElConfig t
  , _content :: Restrict HeaderContent m a
  }

data HeaderContent
data Header

data SubHeader m a = SubHeader
  { _content :: Restrict Inline m a
  }