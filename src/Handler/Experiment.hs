module Handler.Experiment where

import Import

getExperimentR :: Handler Value
getExperimentR = return $ object ["msg" .= ("This is an experiment" :: Text)]

postExperimentR :: Handler Value
postExperimentR = do
    experiment <- requireJsonBody :: Handler Experiment
    subjId <- runDB $ insert $ subject experiment
    -- _ <- runDB $ insert
    return $ object ["msg" .= ("success" :: Text)]
