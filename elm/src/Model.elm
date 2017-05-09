module Model exposing (..)

import Http
import User exposing (..)


type alias Model =
    { users : List User
    , formAction : FormAction
    , selectedUser : Maybe Int
    , nextUserId : Int
    , errors : Maybe Http.Error
    , nameInput : String
    , emailInput : String
    , ageInput : String
    , stoogeInput : String
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
    , nameInput = ""
    , emailInput = ""
    , ageInput = ""
    , stoogeInput = ""
    }



-- Update


type Msg
    = NoOp
    | EditUser Int
    | DeleteUser Int
    | NewUser
    | ProcessUserGet (Result Http.Error (List User))
    | ProcessUserPost (Result Http.Error User)
    | SetNameInput String
    | SetEmailInput String
    | SetAgeInput String
    | SetStoogeInput String
    | UserPost Model