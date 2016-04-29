module Main where

import Control.Monad

import Text.Layout.Table

main :: IO ()
main = putStrLn $ layoutTableToString rowGroups
                                      (Just (["Layout", "Result"], repeat def))
                                      [ LayoutSpec (ExpandUntil 30) left (charAlign ':') ellipsisCutMark
                                      , LayoutSpec Expand center noAlign noCutMark
                                      ]
                                      unicodeRoundS
  where
    rowGroups    = flip concatMap styles $ \style ->
        flip map layouts $ \layout ->
            rowGroup $ columnsAsGrid center [ explain layout
                                            , genTable layout style
                                            ]
    genTable l s = layoutTableToLines [ rowGroup [ [longText, smallNum, "foo"]
                                                 , [shortText, bigNum, "bar"]
                                                 ]
                                      ]
                                      (Just (["Some text", "Some numbers", "X"], repeat def))
                                      (repeat l)
                                      s
    longText  = "This is long text"
    shortText = "Short"
    bigNum    = "200300400500600.2"
    smallNum  = "4.20000000"
    explain l = case l of
        LayoutSpec lenSpec posSpec alignSpec cutMarkSpec ->
            [ "length: " ++  show lenSpec
            , "position: " ++ show posSpec
            , "alignment: " ++ if isAligned alignSpec then "at some point" else "not aligned"
            , "cut mark: " ++ show cutMarkSpec
            ]
    styles    = [ asciiRoundS
                , unicodeS
                , unicodeRoundS
                , unicodeBoldS
                , unicodeBoldStripedS
                , unicodeBoldHeaderS
                ]
    layouts   = [ LayoutSpec l p a ellipsisCutMark
                | l <- [Expand, Fixed 10, ExpandUntil 10, FixedUntil 10]
                , p <- [left, right, center]
                , a <- [noAlign, dotAlign]
                ]
