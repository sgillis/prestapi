module Handler.Questionnaire where

import Import
import qualified Data.Text as T

getQuestionnaireR :: Handler RepPlain
getQuestionnaireR = do
    eqs <- runDB $ selectList [] [] :: Handler [Entity Questions]
    let qs = map extractQuestion eqs
    subqs <- mapM coupleSubject qs
    return $ RepPlain $ toContent $ T.intercalate "\n" $
      header : map questionToLines subqs

extractQuestion :: Entity Questions -> Questions
extractQuestion (Entity _ q) = q

coupleSubject :: Questions -> Handler (Maybe (Subject, Questions))
coupleSubject q = do
    msub <- runDB $ get (questionsSubject q)
    case msub of
         Nothing -> return Nothing
         Just s -> return $ Just (s, q)

header :: Text
header = T.intercalate ";"
    [ "experimenter"
    , "rater"
    , "question"
    , "answer"
    , "remark"
    , "start"
    , "end"
    ]

questionToLines :: Maybe (Subject, Questions) -> Text
questionToLines Nothing = ""
questionToLines (Just sq) =
    T.intercalate "\n" $ map (questionToLine sq)
        [ ("age", T.pack . show . questionsAge, noRemark)
        , ("sex", questionsSex, noRemark)
        , ("question1", questionsQuestion1, maybeText . questionsRemark1)
        , ("question2", questionsQuestion2, maybeText . questionsRemark2)
        , ("question3", questionsQuestion3, maybeText . questionsRemark3)
        , ("question4", questionsQuestion4, maybeText . questionsRemark4)
        , ("question5", questionsQuestion5, maybeText . questionsRemark5)
        , ("question6", questionsQuestion6, maybeText . questionsRemark6)
        , ("question7", questionsQuestion7, maybeText . questionsRemark7)
        , ("question8", questionsQuestion8, maybeText . questionsRemark8)
        , ("question9", questionsQuestion9, maybeText . questionsRemark9)
        , ("question10", questionsQuestion10, maybeText . questionsRemark10)
        , ("question11", questionsQuestion11, noRemark)
        , ("question12", questionsQuestion12, noRemark)
        ]
    where
        noRemark = \_ -> ("" :: Text)

questionToLine :: (Subject, Questions)
               -> (Text, (Questions -> Text), (Questions -> Text)) -> Text
questionToLine (s, q) (questionName, getQuestion, getRemark) =
    T.intercalate ";" [ experimenter
                      , rater
                      , questionName
                      , getQuestion q
                      , getRemark q
                      , start
                      , end ]
      where
          experimenter = subjectExperimenter s
          rater = subjectNumber s
          start = T.pack $ show $ subjectStartDate s
          end = T.pack $ show $ subjectEndDate s

maybeText :: Maybe Text -> Text
maybeText Nothing  = ""
maybeText (Just t) = t
