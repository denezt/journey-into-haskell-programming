{-# LANGUAGE OverloadedStrings #-}

module Scraper 
  (
    fetchHtml, 
    extractTitle, 
    extractLinks, 
    filterLinks
  ) where

-- Module for web scraping: fetching HTML, extracting titles and links, filtering links by keyword. -
import qualified Data.ByteString.Lazy as BL
import           Data.Text (Text)
import qualified Data.Text as T
import           Data.Text.Encoding (decodeUtf8With)
import           Data.Text.Encoding.Error (lenientDecode)
import           Network.HTTP.Simple
import           Text.HTML.TagSoup

-- Fetch HTML as strict Text (best-effort decoding)
fetchHtml :: String -> IO Text
fetchHtml url = do
  request  <- parseRequest url
  response <- httpLBS request
  let body = BL.toStrict (getResponseBody response)
  pure $ decodeUtf8With lenientDecode body

-- Extract the <title> contents (first one found)
extractTitle :: Text -> Maybe Text
extractTitle html =
  let tags = parseTags html :: [Tag Text]
  in case dropWhile (~/= TagOpen ("title" :: Text) []) tags of
       (_:rest) ->
         let titleBits = takeWhile (~/= TagClose ("title" :: Text)) rest
         in Just . T.strip . innerText $ titleBits
       _ -> Nothing

-- Extract all (href, text) from <a ...>...</a>
extractLinks :: Text -> [(Text, Text)]
extractLinks html =
  let tags    = parseTags html :: [Tag Text]
      isA (TagOpen "a" _) = True
      isA _               = False
      anchors = partitions isA tags
      openTag (t:_) = t
      openTag _     = TagOpen ("a" :: Text) []
      extract ts =
        let href = T.strip $ fromAttrib "href" (openTag ts)
            txt  = T.strip $ T.concat [fromTagText t | t <- ts, isTagText t]
        in (href, txt)
  in map extract anchors

-- Filter links by keyword (in href or text)
filterLinks :: Text -> [(Text, Text)] -> [(Text, Text)]
filterLinks kw =
  let f = T.toCaseFold kw
  in filter (\(h,t) -> f `T.isInfixOf` T.toCaseFold h
                    || f `T.isInfixOf` T.toCaseFold t)
