--Fabiola Maria Kretzer

import Data.Binary
import Data.Binary.Get
import Data.Binary.Put
import qualified Data.ByteString.Lazy as BS
import Data.ByteString.Lazy (ByteString)
import System.Environment
import System.FilePath
import System.IO

main = do
    args <- getArgs
    case args of
        [filename] -> do
            input <- BS.readFile filename
            let prefix = takeBaseName filename
            let bitmap = getBitmap input
            splitFileText prefix bitmap

-------xxxxxxxxxxxxxxxxx-----

data BMPHeader = BMPHeader {
    bm :: Word16,
    size :: Word32,
    u1 :: Word16,
    u2 :: Word16,
    offset :: Word32
} deriving (Show)

getBMPHeader :: Get BMPHeader
getBMPHeader = do
    bm <- getWord16le
    size <- getWord32le
    u1 <- getWord16le
    u2 <- getWord16le
    offset <- getWord32le
    return $ BMPHeader bm size u1 u2 offset

-------xxxxxxxxxxxxxxxxx-----

data DIBHeader = DIBHeader {
    headerSize :: Word32,
    width :: Word32,
    height :: Word32,
    planes :: Word16,
    bpp :: Word16,
    compression :: Word32,
    dataSize :: Word32,
    ppmh :: Word32,
    ppmv :: Word32,
    palleteSize :: Word32,
    important :: Word32
} deriving (Show)

getDIBHeader :: Get DIBHeader
getDIBHeader = do
    headerSize <- getWord32le
    width <- getWord32le
    height <- getWord32le
    planes <- getWord16le
    bpp <- getWord16le
    compression <- getWord32le
    dataSize <- getWord32le
    ppmh <- getWord32le
    ppmv <- getWord32le
    palleteSize <- getWord32le
    important <- getWord32le
    return (DIBHeader headerSize width height planes bpp compression dataSize
            ppmh ppmv palleteSize important)


getHeaders :: Get (BMPHeader, DIBHeader)
getHeaders = do
    b <- getBMPHeader
    d <- getDIBHeader
    return (b, d)

-------xxxxxxxxxxxxxxxxx-----

data Bitmap = Bitmap {
   bmp :: BMPHeader,
   dib :: DIBHeader,
   bytes :: ByteString
}

getBitmap :: ByteString -> Bitmap
getBitmap bytes = let
    (b, d) = runGet getHeaders bytes
    o = fromIntegral $ offset b
    in Bitmap b d (BS.drop o bytes)

-------xxxxxxxxxxxxxxxxx-----

data BGRPixel = BGRPixel {
   b :: Word8,
   g :: Word8,
   r :: Word8
}

type BGR = ([Word8], [Word8], [Word8])
type BGRList = [[Word8]]

bytesPerPixel :: Bitmap -> Int
bytesPerPixel bmp = bitsPerPixel `div` 8
    where bitsPerPixel = fromIntegral $ bpp (dib bmp)

getRows :: Int -> Int -> [Word8] -> [[Word8]]
getRows _ _ [] = []
getRows width bpp bytes = row:(getRows width bpp remainder)
    where p = (4 - (width * bpp `mod` 4)) `mod` 4
          size = width * bpp
          (padded, remainder) = splitAt (size+p) bytes
          row = take size padded

rowToPixels :: [Word8] -> [BGRPixel]
rowToPixels [] = []
rowToPixels row = let
    ([b, g, r], remainder) = splitAt 3 row
    in (BGRPixel b g r):(rowToPixels remainder)

getPixels :: Bitmap -> [BGRPixel]
getPixels bmp = let
    w = fromIntegral $ width (dib bmp)
    bpp = bytesPerPixel bmp
    rows = getRows w bpp . BS.unpack $ bytes bmp
    in concat $ map rowToPixels rows

splitBGR :: [BGRPixel] -> BGR
splitBGR [] = ([], [], [])
splitBGR (BGRPixel b g r:ps) = (b:bs, g:gs, r:rs)
    where (bs, gs, rs) = splitBGR ps

toList :: (a, a, a) -> [a]
toList (b, g, r) = [b, g, r]

bmpToBGR :: Bitmap -> BGR
bmpToBGR = splitBGR . getPixels

toFloat :: Word8 -> Float
toFloat color = fromIntegral color / 255

closeAll :: [Handle] -> IO [()]
closeAll handlers = sequence $ map hClose handlers

openAll :: [String] -> IO [Handle]
openAll filenames = sequence [openFile filename WriteMode | filename <- filenames]

outputAll :: (Handle -> a -> IO ()) -> [Handle] -> [a] -> IO [()]
outputAll outputFunction filenames contents = do
    sequence [outputFunction filename contents | (filename, contents) <- zip filenames contents]

splitFileText :: String -> Bitmap -> IO ()
splitFileText prefix bitmap = do
    outputs <- openAll $ map (prefix++) ["_blue.out", "_green.out", "_red.out"]
    outputAll hPrint outputs $ [map toFloat color | color <- toList $ bmpToBGR bitmap]
    closeAll outputs
    return ()

--Baseado no trabalho de
--Copyright (c) 2016 Salomão Rodrigues Jacinto
