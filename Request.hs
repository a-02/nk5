{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Request where

import Control.Lens.At as At
import Data.Aeson
import Data.Aeson.Lens
import Data.Bits
import Data.ByteString as BS
import qualified Data.ByteString.Lazy as BSL
import Data.Foldable
import Data.List as L
import Lens.Micro as Micro
import Network.Wreq
import System.Directory

sbdb :: Int -> String
sbdb x = "https://ssd-api.jpl.nasa.gov/sbdb.api?des=" ++ show x ++ "&phys-par=1"

linesBS :: ByteString -> [ByteString]
linesBS = BS.split 10

step1 :: IO ()
step1 = do
  allInForm <- listDirectory "/root/form"
  allInMagic <- listDirectory "/root/magic"
  everything <- mconcat $ BS.readFile <$> (allInForm ++ allInMagic)
  createDirectoryIfMissing False "/root/tmp/allFortunes"
  BS.writeFile "/root/tmp/allFortunes" everything

gematria :: ByteString -> Int
gematria bs = fromIntegral . sum $ flip rotate 1 . complement <$> unpack bs

step2 = do
  allFortunes <- linesBS <$> BS.readFile "/root/tmp/allFortunes"
  BS.writeFile "/root/tmp/sortedFortunes" $ mconcat $ L.sortOn gematria allFortunes

-- ahahahahaha FUCK u nasa.
step3 :: IO [Double]
step3 = do
  allFortunes <- linesBS <$> BS.readFile "/root/tmp/sortedFortunes"
  let lengthF = fromIntegral $ L.length allFortunes
      maxFortunesPerPlanet = 20
      adjustedLengthF = ceiling $ lengthF / maxFortunesPerPlanet
      collapse :: Maybe (Result String) -> String = fold . fold -- hmm?
      badMass x = fromJSON <$> x ^? responseBody . key "phys_par" . nth 2 . key "value"
      fixNASA x = if L.last x == '.' then x ++ pure '0' else x
  rs <- traverse (get . sbdb) [1 .. adjustedLengthF]
  return $ ((read :: String -> Double) . fixNASA . collapse . badMass) <$> rs
