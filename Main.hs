{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Prelude hiding (head, id, div)

import qualified Data.Text.Lazy.IO       as TLIO (appendFile, writeFile)

import qualified Data.ByteString.Lazy    as BSL

import Web.Scotty

import Network.HTTP.Types.Status
import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger

import Text.Blaze.Html.Renderer.Text (renderHtml)

import Control.Monad.IO.Class

import qualified Clay as CSS (render)

import Content (home)
import Style (fullStyle)

main :: IO () 
main = do
  let static = "/root/www/static";
      form = "/root/www/form";
  TLIO.writeFile (static ++ "/index.css") $ CSS.render fullStyle
  scotty 80 do
    middleware $ staticPolicy (noDots <> addBase "/root/www/static")
    middleware logStdoutDev
    get "/" do
      html $ renderHtml home
    post "/test" do
      (theInput :: BSL.ByteString) <- param "fortune"
      liftIO $ 
        BSL.appendFile 
          (form ++ "/userFortunes") 
          (theInput <> "\n")
      redirect "/"
      status accepted202 
