{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Clay as CSS
  ( render,
  )
import Content (home)
import Control.Monad
import Control.Monad.IO.Class
import qualified Data.ByteString as BS
import Data.ByteString.Internal
import qualified Data.ByteString.Lazy as BSL
import Data.Char
import qualified Data.Text.Lazy.IO as TLIO
  ( appendFile,
    writeFile,
  )
import Network.HTTP.Types.Status
import Network.Wai.Middleware.RequestLogger
import Network.Wai.Middleware.Static
import Request
import Style (fullStyle)
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Web.Scotty
import Prelude hiding
  ( div,
    head,
    id,
  )

-- to those who say that it is unsafe to run a webserver through root with no
-- https, i dont care yet.

main :: IO ()
main = do
  let static = "/root/www/static"
  TLIO.writeFile (static ++ "/index.css") $ CSS.render fullStyle
  scotty 80 do
    middleware $ staticPolicy (noDots <> addBase "/root/www/static")
    middleware logStdoutDev
    get "/" do
      html $ renderHtml home
    post "/test" do
      (theInput :: BS.ByteString) <- param "fortune"
      liftIO $ BS.appendFile ("/root/form/userFortunes") (testResult theInput)
      redirect "/"
      status accepted202

-- the below is awfully american. im sorry about that

isEmpty :: BS.ByteString -> Maybe BS.ByteString
isEmpty bs = if BS.null bs then Nothing else Just bs

isLongerThan3 :: ByteString -> Maybe ByteString
isLongerThan3 bs =
  if BS.length bs <= 3
    then Nothing
    else Just bs

isSpaced :: ByteString -> Maybe ByteString
isSpaced bs =
  if BS.any (\x -> w2c x == ' ') bs
    then Just bs
    else Nothing

isWellCapped :: BS.ByteString -> Maybe BS.ByteString
isWellCapped bs =
  let x = w2c $ BS.head bs
      y = w2c $ BS.head (BS.tail bs)
   in if isUpper x && isLower y
        then Just bs
        else Nothing

isPunctuated :: BS.ByteString -> Maybe BS.ByteString
isPunctuated bs =
  let x = w2c $ BS.head (BS.reverse bs)
   in if x == '.'
        then Just bs
        else Nothing

fullTest :: ByteString -> Maybe ByteString
fullTest =
  foldl1
    (>=>)
    [ isEmpty,
      isLongerThan3,
      isSpaced,
      isWellCapped,
      isPunctuated
    ]

testResult bs = case fullTest bs of
  Just x -> x <> "\n"
  Nothing -> BS.empty

-- hi, is this a catamorphism?
splitAts :: [Int] -> [a] -> [[a]]
splitAts [] _ = [[]]
splitAts _ [] = [[]]
splitAts (x : xs) as =
  let (ys, zs) = splitAt x as
   in pure ys ++ (splitAts xs zs)
