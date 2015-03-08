{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import

getHomeR :: Handler Value
getHomeR = do
    addHeader "Access-Control-Allow-Origin" "*"
    return $ object ["msg" .= ("Prestapi" :: Text)]
