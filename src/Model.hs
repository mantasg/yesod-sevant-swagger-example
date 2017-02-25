{-# LANGUAGE DeriveGeneric #-}

module Model where

import Yesod
import GHC.Generics
import Data.Swagger hiding (get)

import Database

data Entity' = Entity' { id :: Int, name :: String } deriving (Generic)
instance ToJSON Entity'
instance ToSchema Entity'

data SampleRequest = SampleRequest { field1  :: String, field2 :: Maybe String } deriving (Generic)
instance ToJSON SampleRequest
instance FromJSON SampleRequest
instance ToSchema SampleRequest

data CarModel = CarModel { make :: String  } deriving (Generic)
instance ToSchema CarModel
instance ToJSON CarModel

carFromEntity :: Car -> CarModel
carFromEntity entity = CarModel (carMake entity)
