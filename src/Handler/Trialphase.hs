module Handler.Trialphase where

import Import
import qualified Data.Text as T

getTrialphaseR :: Handler RepPlain
getTrialphaseR = do
    ers <- runDB $ selectList [ RatingPractice ==. True ] [ ]
    let rs = map extractRate ers
    subrs <- mapM coupleSubject rs
    return $ RepPlain $ toContent $ T.intercalate "\n" $
        header : map rateToLine subrs

header :: Text
header = T.intercalate ";"
    [ "experimenter"
    , "rater"
    , "stimulus"
    , "repetition"
    , "rate"
    , "position"
    , "correct"
    , "start"
    , "end"
    ]

extractRate :: Entity Rating -> Rating
extractRate (Entity _ r) = r

coupleSubject :: Rating -> Handler (Maybe (Subject, Rating))
coupleSubject r = do
    msub <- runDB $ get (ratingSubject r)
    case msub of
         Nothing -> return Nothing
         Just s -> return $ Just (s, r)

rateToLine :: Maybe (Subject, Rating) -> Text
rateToLine Nothing       = ""
rateToLine (Just (s, r)) = T.intercalate ";"
    [ experimenter
    , rater
    , stimulus
    , repetition
    , rate
    , position
    , correct
    , start
    , end ]
      where
          experimenter = subjectExperimenter s
          rater = subjectNumber s
          stimulus = ratingSample r
          repetition = T.pack $ show $ ratingRepeats r
          rate = T.pack $ show $ ratingRate r
          position = T.pack $ show $ ratingPosition r
          correct = correctRating r
          start = T.pack $ show $ subjectStartDate s
          end = T.pack $ show $ subjectEndDate s

correctRating :: Rating -> Text
correctRating r =
    if "iamb" `T.isInfixOf` ratingSample r
    then if ratingRate r >= 60
         then "y"
         else "n"
    else if ratingRate r <= 40
         then "y"
         else "n"
