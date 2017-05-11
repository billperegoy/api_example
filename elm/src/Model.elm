module Model exposing (..)

import Http
import User exposing (..)


type alias Model =
    { users : List User
    , formAction : FormAction
    , selectedUser : Maybe Int
    , errors : Maybe Http.Error
    , nameInput : String
    , emailInput : String
    , ageInput : String
    }


type FormAction
    = Create
    | Edit
    | Delete
    | None


init : Model
init =
    { users = []
    , formAction = None
    , selectedUser = Nothing
    , errors = Nothing
    , nameInput = ""
    , emailInput = ""
    , ageInput = ""
    }


type Msg
    = EditUser Int
    | DeleteUser Int
    | NewUser
    | ProcessUserGet (Result Http.Error (List User))
    | ProcessUserResponse (Result Http.Error User)
    | SetNameInput String
    | SetEmailInput String
    | SetAgeInput String
    | UserPost Model
    | UserPut Model
    | UserDelete Model
