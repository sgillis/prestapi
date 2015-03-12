{-# LANGUAGE FlexibleInstances #-}

module Model where

import Yesod
import Data.Text (Text)
import Database.Persist.Quasi
import Data.Typeable (Typeable)
import Prelude
import Data.Time
import Control.Applicative
import Control.Monad
import Data.Aeson
import Data.ByteString

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")

data Experiment = Experiment
    { subject :: Subject
    , questions :: QuestionsInput
    , ratings :: [RatingInput]
    , authentication :: AuthenticationInput
    }

data AuthenticationInput = AuthenticationInput
    { username :: Text
    , password :: Text
    }

data QuestionsInput = QuestionsInput
    { age :: Int
    , sex :: Text
    , question1 :: Text
    , question2 :: Text
    , question3 :: Text
    , question4 :: Text
    , question5 :: Text
    , question6 :: Text
    , question7 :: Text
    , question8 :: Text
    , question9 :: Text
    , question10 :: Text
    , question11 :: Text
    , remark1 :: Maybe Text
    , remark2 :: Maybe Text
    , remark3 :: Maybe Text
    , remark4 :: Maybe Text
    , remark5 :: Maybe Text
    , remark6 :: Maybe Text
    , remark7 :: Maybe Text
    , remark8 :: Maybe Text
    , remark9 :: Maybe Text
    , remark10 :: Maybe Text
    }

data RatingInput = RatingInput
    { sample :: Text
    , rating :: Int
    , position :: Int
    , repeats :: Int
    }

instance FromJSON AuthenticationInput where
    parseJSON (Object o) = AuthenticationInput
        <$> o .: "username"
        <*> o .: "password"
    parseJSON _ = mzero

instance FromJSON Subject where
    parseJSON (Object o) = Subject <$> o .: "number"
    parseJSON _ = mzero

instance ToJSON (Entity Subject) where
    toJSON (Entity _ s) = object
        [ "number" .= subjectNumber s ]

instance ToJSON (Entity Questions) where
    toJSON (Entity _ q) = object
        [ "age" .= questionsAge q
        , "sex" .= questionsSex q
        , "question1" .= questionsQuestion1 q
        , "question2" .= questionsQuestion2 q
        , "question3" .= questionsQuestion3 q
        , "question4" .= questionsQuestion4 q
        , "question5" .= questionsQuestion5 q
        , "question6" .= questionsQuestion6 q
        , "question7" .= questionsQuestion7 q
        , "question8" .= questionsQuestion8 q
        , "question9" .= questionsQuestion9 q
        , "question10" .= questionsQuestion10 q
        , "question11" .= questionsQuestion11 q
        , "remark1" .= questionsRemark1 q
        , "remark2" .= questionsRemark2 q
        , "remark3" .= questionsRemark3 q
        , "remark4" .= questionsRemark4 q
        , "remark5" .= questionsRemark5 q
        , "remark6" .= questionsRemark6 q
        , "remark7" .= questionsRemark7 q
        , "remark8" .= questionsRemark8 q
        , "remark9" .= questionsRemark9 q
        , "remark10" .= questionsRemark10 q
        ]

instance ToJSON (Entity Rating) where
    toJSON (Entity _ r) = object
        [ "sample" .= ratingSample r
        , "rate" .= ratingRate r
        , "position" .= ratingPosition r
        , "repeats" .= ratingRepeats r
        ]

instance FromJSON QuestionsInput where
    parseJSON (Object o) = QuestionsInput
        <$> o .: "age"
        <*> o .: "sex"
        <*> o .: "question1"
        <*> o .: "question2"
        <*> o .: "question3"
        <*> o .: "question4"
        <*> o .: "question5"
        <*> o .: "question6"
        <*> o .: "question7"
        <*> o .: "question8"
        <*> o .: "question9"
        <*> o .: "question10"
        <*> o .: "question11"
        <*> o .:? "remark1"
        <*> o .:? "remark2"
        <*> o .:? "remark3"
        <*> o .:? "remark4"
        <*> o .:? "remark5"
        <*> o .:? "remark6"
        <*> o .:? "remark7"
        <*> o .:? "remark8"
        <*> o .:? "remark9"
        <*> o .:? "remark10"
    parseJSON _ = mzero

instance FromJSON RatingInput where
    parseJSON (Object o) = RatingInput
        <$> o .: "sample"
        <*> o .: "rating"
        <*> o .: "position"
        <*> o .: "repeats"
    parseJSON _ = mzero

instance FromJSON Experiment where
    parseJSON (Object o) = Experiment
        <$> o .: "subject"
        <*> o .: "questions"
        <*> o .: "ratings"
        <*> o .: "authentication"
    parseJSON _ = mzero
