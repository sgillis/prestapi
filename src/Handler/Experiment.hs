module Handler.Experiment where

import Import
import Data.Time
import Crypto.PasswordStore
import Data.Text.Encoding

getExperimentR :: Text -> Handler Value
getExperimentR subjNumber = do
    mexp <- runDB $ do
        subj <- getBy $ UniqueSubject subjNumber
        case subj of
             Nothing -> return Nothing
             Just (Entity sid _) -> do
                 question <- getBy $ UniqueQuestions sid
                 rs <- selectList [ RatingSubject ==. sid ] [ ]
                 return $ Just (subj, question, rs)
    case mexp of
         Just (subj, question, rs) -> return $ object
            [ "subject" .= subj
            , "questions" .= question
            , "ratings" .= rs
            ]
         _ -> return $ object [ "msg" .= ("No subject" :: Text) ]

postSubmitExperimentR :: Handler Value
postSubmitExperimentR = do
    addHeader "Access-Control-Allow-Origin" "*"
    experiment <- requireJsonBody :: Handler Experiment
    let authinput = authentication experiment
        user = username authinput
        pass = password authinput
    mauth <- runDB $ getBy $ UniqueAuthentication user
    case mauth of
         Nothing -> return $ object [ "success" .= False ]
         Just (Entity _ auth) -> do
           let valid = verifyPassword (encodeUtf8 pass)
                                      (authenticationPassword auth)
           case valid of
                True -> do
                   time <- liftIO $ getZonedTime >>= \time -> return $ zonedTimeToUTC time
                   _ <- runDB $ do
                       subjId <- insert $ subject experiment
                       _ <- insert $ constructQuestion subjId time (questions experiment)
                       let rs = map (constructRating subjId) (ratings experiment)
                       mapM insert rs
                   return $ object [ "success" .= True ]
                False -> return $ object [ "success" .= False ]

constructQuestion :: SubjectId -> UTCTime -> QuestionsInput -> Questions
constructQuestion sid time input = Questions
    sid time
    (age input)
    (sex input)
    (question1 input)
    (question2 input)
    (question3 input)
    (question4 input)
    (question5 input)
    (question6 input)
    (question7 input)
    (question8 input)
    (question9 input)
    (question10 input)
    (question11 input)
    (remark1 input)
    (remark2 input)
    (remark3 input)
    (remark4 input)
    (remark5 input)
    (remark6 input)
    (remark7 input)
    (remark8 input)
    (remark9 input)
    (remark10 input)

constructRating :: SubjectId -> RatingInput -> Rating
constructRating sid input = Rating
    sid (sample input) (rating input) (position input) (repeats input)
