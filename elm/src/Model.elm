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
    , userHttpResponse : UserListHttpResponse
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
    , userHttpResponse = UserListNoResponse
    }


type Msg
    = ShowCreateUserForm
    | CreateUser Model
    | ShowUpdateUserForm Int
    | UpdateUser Model
    | ShowDeleteUserForm Int
    | DeleteUser Model
    | ProcessUserListResponse (Result Http.Error (UserListResponse))
    | ProcessUserResponse (Result Http.Error UserResponse)
    | SetNameInput String
    | SetEmailInput String
    | SetAgeInput String
