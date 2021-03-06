module Database.User where

import Control.Arrow (returnA)
import Data.Text (Text)
import Database.Common
import Database.Model
import GHC.Int (Int64)
import Opaleye

-------------------------------------------------------------------------------
userSelect :: Select UserField
userSelect = selectTable userTable

-------------------------------------------------------------------------------
insertUser :: (Text, Text, Text) -> Insert Int64
insertUser (userEmail, userPasswordHash, userName) =
    Insert
        { iTable = userTable
        , iRows =
              [ UserData
                    { userId = Nothing
                    , userEmail = toFields userEmail
                    , userPasswordHash = toFields userPasswordHash
                    , userName = toFields userName
                    }
              ]
        , iReturning = rCount
        , iOnConflict = Nothing
        }

-------------------------------------------------------------------------------
findUserByEmail :: Text -> Select UserField
findUserByEmail email =
    proc () ->
  do user <- userSelect -< ()
     restrict -< (userEmail user) .== toFields email
     returnA -< user
