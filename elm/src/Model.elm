module Model exposing (..)

import Http
import User exposing (..)


type alias Model =
    { users : List User
    , formAction : FormAction
    , selectedUser : Maybe Int
    , nextUserId : Int
    , errors : Maybe Http.Error
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None


init : Model
init =
    { users = initUsers
    , formAction = None
    , selectedUser = Nothing
    , nextUserId = 3
    , errors = Nothing
    }



-- Update


type Msg
    = NoOp
    | EditUser Int
    | DeleteUser Int
    | NewUser
    | ProcessUserGet (Result Http.Error (List User))
