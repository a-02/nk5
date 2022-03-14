{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PostfixOperators #-}

module Style where

import Clay
import Clay.Font
import Clay.FontFace

-- note: this is the how it looks to document.styleSheets[0].cssRules
fullStyle = do
  corporate
  commenting "i dont care about any screen that isnt 1600x900" bodyDef
  h3Def
  h6Def
  pDef
  topleftDef
  dayDef
  nightDef
  fortuneDef

corporate :: Css
corporate = fontFace $ do
  fontFamily ["Corporate"] []
  fontFaceSrc [FontFaceSrcUrl "Corporate_A.woff2" (Just WOFF2)]

bodyDef :: Css
bodyDef =
  body ? do
    fontFamily ["Corporate", "Georgia"] [serif]
    display flex
    alignItems center
    justifyContent center
    flexDirection column
    height $ pct 100
    fontWeight (weight 100)
    margin (vh 42) (px 0) (px 0) (px 0)

h3Def =
  h3 ? do
    fontSize $ px 60
    letterSpacing $ px (-3)
    noMargin

h6Def =
  h6 ? do
    fontSize $ px 30
    letterSpacing $ px (-1)
    noMargin
    display flex
    flexDirection row

pDef =
  p ? do
    margin (px 0) (px 60) (px 0) (px 60)

noMargin = margin (px 0) (px 0) (px 0) (px 0)

topleftDef =
  star # byClass "topleft" ? do
    position $ absolute
    top $ px 30
    left $ px 30
    fontFamily ["Corporate", "Georgia"] [serif]
    fontSize $ px 20
    padding (px 4) (px 10) (px 4) (px 10)
    borderStyle solid
    borderWidth $ px 1

dayDef =
  star # byClass "day" ? do
    backgroundColor "#f0e6e9"
    color "#00a550"
    borderColor "#000000"

nightDef =
  star # byClass "night" ? do
    backgroundColor "#000000"
    color "#d9d9d9"
    borderColor "#d9d9d9"

fortuneDef =
  star # byClass "fortune" ? do
    borderStyle solid
    borderWidth $ px 1
    fontFamily ["Corporate", "Georgia"] [serif]
    fontSize $ px 20
    padding (px 4) (px 10) (px 4) (px 10)
    textAlign center
