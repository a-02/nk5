{-# Language OverloadedStrings #-}
{-# Language PostfixOperators #-}

module Style where

import Clay
import Clay.Font
import Clay.FontFace

fullStyle = do
  corporate
  bodyDef
  h3Def
  h6Def
  pDef
  topleftDef

corporate :: Css
corporate = fontFace $
  do fontFamily ["Corporate"] []
     fontFaceSrc [FontFaceSrcUrl "Corporate_A.woff2" (Just WOFF2)]

bodyDef :: Css
bodyDef = body ?
  do backgroundColor "#f0e6e9"
     color "#00a550"
     fontFamily ["Corporate"] [serif]
     display flex
     alignItems center
     justifyContent center
     flexDirection column
     height $ pct 100
     fontWeight (weight 100)
     noMargin

h3Def = h3 ?
  do fontSize $ px 60
     letterSpacing $ px (-3)
     noMargin

h6Def = h6 ?
  do fontSize $ px 30 
     letterSpacing $ px (-1)
     noMargin
     display flex
     flexDirection row

pDef = p ?
  do margin (px 0) (px 60) (px 0) (px 60)

noMargin = margin (px 0) (px 0) (px 0) (px 0)

topleftDef = 
  star # byClass "topleft" ?
    do position $ absolute
       top $ px 30
       left $ px 30
