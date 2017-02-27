{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Model where

import Yesod
import GHC.Generics
import Data.Swagger hiding (get)
import GHC.Int
import Database
import Database.Persist.Sqlite

class ApiModel a e where
  toEntity :: a -> e
  toKey :: a -> Key e
  fromEntity :: Entity e -> a

--- Car
data CarModel = CarModel { id :: Maybe Int64, make :: String  } deriving (Generic)
instance ToSchema CarModel
instance ToJSON CarModel
instance FromJSON CarModel
instance ApiModel CarModel Car where
  toEntity m = Car { carMake = make m }
  toKey (CarModel (Just i) _) = toSqlKey i -- TODO
  fromEntity e = let value = entityVal e
                 in  CarModel { id = Just  (fromSqlKey (entityKey e)), make = carMake value }

toCarUpdate :: CarModel -> [Update Car]
toCarUpdate carModel = [CarMake =. make carModel]

--- Person
data PersonModel = PersonModel { id :: Maybe Int64
                               , name :: String
                               , address :: Maybe String
                               , carId :: Maybe Int64
                               } deriving Generic

instance ToSchema PersonModel
instance ToJSON PersonModel
instance FromJSON PersonModel
instance ApiModel PersonModel Person where
  toEntity (PersonModel _ name' address' carId') = Person name' address' (toSqlKey <$> carId')
  toKey = undefined -- TODO
  fromEntity e = let value = entityVal e
                 in  PersonModel { id = Just $ fromSqlKey (entityKey e)
                                 , name = personName value
                                 , address = personAddress value
                                 , carId = fromSqlKey <$> personCarId value
                                 }
--- Job
data JobModel = JobModel { id :: Maybe Int64
                         , title :: String
                         , description :: Maybe String
                         } deriving Generic

instance ToSchema JobModel
instance ToJSON JobModel
instance FromJSON JobModel
instance ApiModel JobModel Job where
  toEntity (JobModel _ title' description') = Job title' description'
  toKey = undefined
  fromEntity e = let value = entityVal e
                 in  JobModel { id = Just $ fromSqlKey (entityKey e)
                              , title = jobTitle value
                              , description = jobDescription value
                              }
