{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Request where

import Data.Aeson
import Data.Bits
import Data.ByteString as BS
import qualified Data.ByteString.Lazy as BSL
import Data.Foldable
import Data.List as L
import Data.Text (Text)
import GHC.Generics
import Lens.Micro.Extras
import Network.Wreq
import System.Directory

sbdb :: Int -> String
sbdb x = "https://ssd-api.jpl.nasa.gov/sbdb.api?des=" ++ show x ++ "&phys-par=1"

linesBS :: ByteString -> [ByteString]
linesBS = BS.split 10

step1 :: IO ()
step1 = do
  allInForm <- listDirectory "/root/form"
  allInMagic <- listDirectory "/root/magic" -- magic is the stuff I write
  everything <- mconcat $ BS.readFile <$> (allInForm ++ allInMagic)
  createDirectoryIfMissing False "/root/tmp"
  createDirectoryIfMissing False "/root/tmp/allFortunes"
  createDirectoryIfMissing False "/root/tmp/json"
  BS.writeFile "/root/tmp/allFortunes" everything

gematria :: ByteString -> Int
gematria bs = fromIntegral . sum $ flip rotate 1 . complement <$> unpack bs

step2 = do
  allFortunes <- linesBS <$> BS.readFile "/root/tmp/allFortunes"
  BS.writeFile "/root/tmp/sortedFortunes" $ mconcat $ L.sortOn gematria allFortunes

-- todo, split this up!!
step3 = do
  allFortunes <- linesBS <$> BS.readFile "/root/tmp/sortedFortunes"
  let lengthF = fromIntegral $ L.length allFortunes
      maxFortunesPerPlanet = 20
      adjustedLengthF = ceiling $ lengthF / maxFortunesPerPlanet
      numbers = [1 .. adjustedLengthF]
      jsonDir = (\x -> "/root/tmp/json/" ++ x)
  rs <- traverse (get . sbdb) numbers :: IO [Response BSL.ByteString]
  let rsBodies = (toStrict . view responseBody) <$> rs :: [ByteString]
  sequence_ $
    L.zipWith
      BS.writeFile
      ( jsonDir
          <$> L.zipWith (++) (show <$> numbers) (repeat ".json")
      )
      rsBodies

step4 :: IO [[Param]]
step4 = do
  let elimEither x = case x of
        Left _ -> []
        Right x -> L.filter (\Param {name} -> name == "diameter") (phys_par x)
  planets <- listDirectory "/root/tmp/json"
  traverse (fmap elimEither . eitherDecodeFileStrict') planets

-- thank you hecate

data Phys = Phys
  { phys_par :: [Param]
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON)

data ObjParam = ObjParam
  {object :: Obj}
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON)

data Obj = Obj
  {shortname :: String}
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON)

data Param = Param
  { name :: Text,
    value :: Text
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (FromJSON)

test3a :: IO [Param]
test3a = do
  rs <- eitherDecodeFileStrict' "./nasa.json"
  return $ case rs of
    Left _ -> []
    Right x -> L.filter (\Param {name} -> name == "diameter") (phys_par x)
