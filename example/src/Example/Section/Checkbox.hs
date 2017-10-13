{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE RecursiveDo          #-}
{-# LANGUAGE RecordWildCards      #-}
{-# LANGUAGE ScopedTypeVariables  #-}
{-# LANGUAGE TemplateHaskell      #-}

{-# OPTIONS_GHC -Wno-unused-do-bind #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Example.Section.Checkbox where

import GHC.Tuple -- TH requires this for (,)
import Control.Lens
import Data.Semigroup ((<>))
import Reflex.Dom.SemanticUI

import Example.QQ
import Example.Common

checkboxes :: forall t m. MonadWidget t m => Section m
checkboxes = LinkedSection "Checkbox" (simpleLink "https://semantic-ui.com/modules/checkbox.html") $ do

  ui $ Message $ def
    & messageType |?~ InfoMessage
    & message ?~ (do
      ui $ Icon "announcement" def
      text "The implementation of the Checkbox module does not depend on the Semantic UI or jQuery Javascript libraries.")

  ui $ Paragraph $ text "Checkboxes consist of a label and a configuration."

  hscode $(printDefinition id stripParens ''Checkbox)

  ui $ Paragraph $ text "The configuration allows you to set the value, indeterminate state, Semantic UI checkbox type, fitted property, and disabled state. The value and indeterminate states are separated into 'initial' and 'set' in order to disconnect them from the resultant dynamic values."

  hscode $(printDefinition id stripParens ''CheckboxConfig)
  hscode $(printDefinition oneline id ''CheckboxType)

  ui $ Paragraph $ do
    text "Running the checkbox gives access to the dynamic value, the change event (only changes caused by the user), the current indeterminate state and whether the checkbox has focus."

  hscode $(printDefinition id stripParens ''CheckboxResult)

  ui $ PageHeader H3 def $ ui $ Content def $ text "Examples"

  divClass "ui two column stackable grid" $ do
    divClass "row" $ do

      divClass "column" $ do
        exampleCardDyn dynCode "Checkbox" "Standard checkbox styles" $ [mkExample|
        \resetEvent -> do
          normal <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "Normal checkbox"
            $ def & setValue .~ (False <$ resetEvent)
          toggle <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "Toggle checkbox (checked by default)"
            $ def & altType |?~ Toggle
                  & setValue .~ (True <$ resetEvent)
                  & initialValue .~ True
          slider <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "Slider checkbox"
            $ def & altType |?~ Slider
                  & setValue .~ (False <$ resetEvent)
          return $ traverse (view value) [normal, toggle, slider]
        |]

      divClass "column" $ do
        exampleCardDyn dynCode "Disabled checkbox" "Checkboxes can be enabled or disabled" [mkExample|
        \resetEvent -> do
          enable <- ui $ Button "Enable" $ def
            & attached |?~ Horizontally LeftAttached
          disable <- ui $ Button "Disable" $ def
            & attached |?~ Horizontally RightAttached
          enabled <- holdDyn False $ leftmost [True <$ enable, False <$ disable, False <$ resetEvent]
          normal <- ui $ Segment def
            $ ui $ Checkbox "Initially disabled"
            $ def & setValue .~ (False <$ resetEvent)
                  & disabled .~ Dynamic (fmap not enabled)
          toggle <- ui $ Segment def
            $ ui $ Checkbox "Initially disabled (checked by default)"
            $ def & altType |?~ Toggle
                  & setValue .~ (True <$ resetEvent)
                  & initialValue .~ True
                  & disabled .~ Dynamic (fmap not enabled)
          return $ traverse (view value) [normal, toggle]
        |]

    divClass "row" $ do

      divClass "column" $ do
        exampleCardDyn dynShowCode "Checkbox states" "Checkboxes can be indeterminate" [mkExample|
        \resetEvent -> do
          indeterminateButton <- ui $ Button "Indeterminate" $ def
            & attached |?~ Horizontally LeftAttached
          determinateButton <- ui $ Button "Determinate" $ def
            & attached |?~ Horizontally RightAttached
          ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "Indeterminate"
            $ def & setValue .~ (True <$ resetEvent)
                  & setIndeterminate .~ leftmost
                      [ True <$ indeterminateButton
                      , False <$ determinateButton
                      , True <$ resetEvent ]
                  & initialIndeterminate .~ True
                  & initialValue .~ True
        |]

      divClass "column" $ do
        exampleCardDyn dynCode "Fitted checkbox" "A fitted checkbox does not leave padding for a label" [mkExample|
        \resetEvent -> do
          normal <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "" $ def
              & fitted |~ True
              & setValue .~ (False <$ resetEvent)
          slider <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "" $ def
              & fitted |~ True
              & altType |?~ Toggle
              & setValue .~ (False <$ resetEvent)
          toggle <- ui $ Segment (def & compact |~ True)
            $ ui $ Checkbox "" $ def
              & fitted |~ True
              & altType |?~ Slider
              & setValue .~ (False <$ resetEvent)
          return $ traverse (view value) [normal, slider, toggle]
        |]

    return ()
