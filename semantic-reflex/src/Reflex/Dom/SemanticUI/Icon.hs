{-# LANGUAGE ConstraintKinds          #-}
{-# LANGUAGE CPP                      #-}
{-# LANGUAGE DuplicateRecordFields                      #-}
{-# LANGUAGE FlexibleContexts         #-}
{-# LANGUAGE FlexibleInstances        #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE InstanceSigs     #-}
{-# LANGUAGE JavaScriptFFI            #-}
{-# LANGUAGE MultiParamTypeClasses    #-}
{-# LANGUAGE OverloadedStrings        #-}
{-# LANGUAGE OverloadedLists          #-}
{-# LANGUAGE RecordWildCards          #-}
{-# LANGUAGE RecursiveDo              #-}
{-# LANGUAGE ScopedTypeVariables      #-}
{-# LANGUAGE TypeFamilies             #-}
{-# LANGUAGE TypeApplications         #-}
{-# LANGUAGE UndecidableInstances     #-}

module Reflex.Dom.SemanticUI.Icon where

import Data.Foldable (traverse_)
import           Data.Default
import           Data.Semigroup ((<>))
import           Data.Text (Text)
import qualified Data.Text as T
import           Reflex.Dom.Core hiding (fromJSString)
import Data.Maybe (catMaybes)

import           Reflex.Dom.SemanticUI.Common
import           Reflex.Dom.SemanticUI.Label
import           Reflex.Dom.SemanticUI.Header (HeaderContent, Header)
import           Reflex.Dom.SemanticUI.Transition

data Flag t = Flag (Active t Text) (FlagConfig t)

data FlagConfig t = FlagConfig
  { _config :: ActiveElConfig t
  }

instance Default (FlagConfig t) where
  def = FlagConfig def

data Icon t
  = Icon (Active t Text) (IconConfig t)
  | Icons [Icon t] (IconsConfig t)

data IconConfig t = IconConfig
  { _disabled :: Active t Bool
  , _loading :: Active t Bool
  , _fitted :: Active t Bool
  , _size :: Active t (Maybe Size)
  , _link :: Active t Bool
  , _floated :: Active t (Maybe Floated)
  , _title :: Active t (Maybe Text)
  , _circular :: Active t Bool
--  , _flipped :: Bool
--  , _rotated :: Bool
--  , _circular :: Bool
--  , _bordered :: Bool
  , _inverted :: Active t Bool
  , _color :: Active t (Maybe Color)
  , _config :: ActiveElConfig t
  }

instance Reflex t => Default (IconConfig t) where
  def = IconConfig
    { _disabled = pure False
    , _loading = pure False
    , _fitted = pure False
    , _size = pure Nothing
    , _link = pure False
    , _floated = pure Nothing
    , _title = pure Nothing
    , _circular = pure False
    , _inverted = pure False
    , _color = pure Nothing
    , _config = def
    }

iconConfigClasses :: Reflex t => IconConfig t -> Active t Classes
iconConfigClasses IconConfig {..} = activeClasses
  [ Static $ Just "icon"
  , boolClass "disabled" _disabled
  , boolClass "loading" _loading
  , boolClass "fitted" _fitted
  , boolClass "link" _link
  , boolClass "circular" _circular
  , boolClass "inverted" _inverted
  , fmap toClassText . nothingIf Medium <$> _size
  , fmap toClassText <$> _floated
  , fmap toClassText <$> _color
  ]

data IconsConfig t= IconsConfig
  { _size :: Active t (Maybe Size)
  , _config :: ActiveElConfig t
  }

instance Default (IconsConfig t) where
  def = IconsConfig
    { _size = Static Nothing
    , _config = def
    }

iconsConfigClasss :: Reflex t => IconsConfig t -> Active t Classes
iconsConfigClasss IconsConfig {..} = activeClasses
  [ Static $ Just "icons"
  , fmap toClassText <$> _size
  ]
