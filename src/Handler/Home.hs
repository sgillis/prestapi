{-# LANGUAGE TupleSections, OverloadedStrings #-}
module Handler.Home where

import Import

getHomeR :: Handler Value
getHomeR = return $ object ["msg" .= ("Prestapi" :: Text)]
