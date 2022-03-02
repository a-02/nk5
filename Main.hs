{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Main where

import Prelude hiding (head, id, div)

import qualified Data.Text.Lazy.IO as TLIO (writeFile)

import Web.Scotty

import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger

import Text.Blaze.Html.Renderer.Text (renderHtml)

import qualified Clay as CSS (render)

import Content (home)
import Style (fullStyle)

main = do
  TLIO.writeFile "/root/www/static/index.css" $ CSS.render fullStyle
  scotty 80 do
    middleware $ staticPolicy (noDots <> addBase "/root/www/static")
    middleware logStdoutDev
    get "/" do
      html $ renderHtml home
