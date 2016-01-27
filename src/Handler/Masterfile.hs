module Handler.Masterfile where

import Import
import Prelude (head)
import qualified Data.Text as T
import Data.Text.IO (readFile)
import Data.List (find)
import Data.String.Utils (rstrip)

getMasterfileR :: Handler RepPlain
getMasterfileR = do
    file <- liftIO $ readFile "/masterfile.csv"
    let csv' = T.lines file
    let csv = map (T.pack . rstrip . T.unpack) csv'
    ers <- runDB $ selectList [ RatingPractice ==. False ] [ ]
    let rs = map extractRate ers
    subrs <- mapM coupleSubject rs
    return $ RepPlain $ toContent $ T.intercalate "\n" $
        ((head csv) `T.append` header) : map (rateToLine csv) subrs

header :: Text
header = "," `T.append` T.intercalate ","
    [ "experimenter"
    , "rater"
    , "stimulus"
    , "repetition"
    , "rate"
    , "position"
    , "start"
    , "end"
    , "list"
    ]

extractRate :: Entity Rating -> Rating
extractRate (Entity _ r) = r

coupleSubject :: Rating -> Handler (Maybe (Subject, Rating))
coupleSubject r = do
    msub <- runDB $ get (ratingSubject r)
    case msub of
         Nothing -> return Nothing
         Just s -> return $ Just (s, r)

rateToLine :: [Text] -> Maybe (Subject, Rating) -> Text
rateToLine _ Nothing       = ""
rateToLine (_:f) (Just (s, r)) =
  fline `T.append` "," `T.append` T.intercalate ","
    [ experimenter
    , rater
    , stimulus
    , repetition
    , rate
    , position
    , start
    , end
    , list ]
      where
          fline = getCsvLine f $ ratingSample r
          experimenter = subjectExperimenter s
          rater = subjectNumber s
          stimulus = ratingSample r
          repetition = T.pack $ show $ ratingRepeats r
          rate = T.pack $ show $ ratingRate r
          position = T.pack $ show $ ratingPosition r
          start = T.pack $ show $ subjectStartDate s
          end = T.pack $ show $ subjectEndDate s
          list = subjectListNumber s

getCsvLine :: [Text] -> Text -> Text
getCsvLine f sample =
    let number line = head $ T.split (==',') line
        
        correctLine sample line =
          number line == (head $ T.split (=='_') sample)
        l = filter (correctLine sample) f
    in case l of
            [l'] -> l'
            [] -> sample
            _ -> "multiple matches"
