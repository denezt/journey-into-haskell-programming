{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import qualified Data.Text as T
import qualified Data.Text.IO as T
import           System.Environment (getArgs)
import           Scraper

usage :: T.Text
usage = T.unlines
  [ "Usage:"
  , "  haskell-webscraper <URL> [keyword]"
  , ""
  , "Examples:"
  , "  haskell-webscraper https://garagebarge.com"
  , "  haskell-webscraper https://garagebarge.com haskell"
  ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    [url] -> run url Nothing
    (url:kw:_) -> run url (Just (T.pack kw))
    _ -> T.putStrLn usage

run :: String -> Maybe T.Text -> IO ()
run url mKw = do
  T.putStrLn $ "Fetching: " <> T.pack url
  html <- fetchHtml url

  case extractTitle html of
    Just ttl -> T.putStrLn $ "Page Title: " <> ttl
    Nothing  -> T.putStrLn   "Page Title: (not found)"

  let links = extractLinks html
      final = maybe links (\kw -> filterLinks kw links) mKw

  T.putStrLn ""
  T.putStrLn "Links:"
  mapM_ printLink final

  where
    printLink (href, txt) =
      T.putStrLn (" - " <> href <> case T.null txt of
                                      True  -> ""
                                      False -> "  [" <> txt <> "]")
