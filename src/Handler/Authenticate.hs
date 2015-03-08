module Handler.Authenticate where

import Import
import Crypto.PasswordStore
import Data.Text.Encoding

postAuthenticateR :: Handler Value
postAuthenticateR = do
    input <- requireJsonBody :: Handler AuthenticationInput
    let user = username input
        pass = password input
    hashedpass <- liftIO $ makePassword (encodeUtf8 pass) 17
    _ <- runDB $ insert $ Authentication user hashedpass
    return $ object [ "success" .= True ]
