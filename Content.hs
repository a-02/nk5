{-# Language OverloadedStrings #-}

module Content where

import Prelude hiding (head)

import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes
import Text.Blaze

home :: Html
home = 
  html $ do
    head $ do
      link ! rel "stylesheet" ! href "/index.css"
      script ! src "/index.js" $ ""
    body $ do
      input ! type_ "button" ! class_ "topleft"
      h3 "Click here to receive your fortune."
      h6 $ do
        p $ myTwitter
        p $ "Hire me. I'm available."
        p $ myGithub

myTwitter = a ! href "https://twitter.com/nikshalark" $ "twitter"
myGithub = a ! href "https://github.com/nikshalark" $ "github"
