{-# LANGUAGE OverloadedStrings #-}

module Content where

import Text.Blaze
import Text.Blaze.Html5
import Text.Blaze.Html5.Attributes hiding
  ( form,
  )
import Prelude hiding
  ( head,
    id,
  )

home :: Html
home = docTypeHtml $ do
  head $ do
    link ! rel "stylesheet"
      ! href "/index.css"
    script ! src "/index.js" $ ""
  body ! class_ "day" $ do
    input ! type_ "button"
      ! class_ "topleft"
      ! id "topleft"
      ! value "Day. / Night." -- light/dark mode
    h3 "Click here to receive your fortune."
    h6 $ do
      p $ myTwitter
      form
        ! action "/test"
        ! method "post"
        ! enctype "application/x-www-form-urlencoded"
        ! class_ "form1"
        $ do
          input
            ! type_ "text"
            ! class_ "fortune"
            ! id "fortune"
            ! name "fortune"
            ! size "30"
            ! maxlength "30"
            ! placeholder "Write another's fortune."
      p $ myGithub

myTwitter = a ! href "https://twitter.com/nikshalark" $ "twitter"

myGithub = a ! href "https://github.com/nikshalark" $ "github"
