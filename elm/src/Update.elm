module Update exposing (update)

import Model exposing (..)
import User
import User.Http


userFormData : Model -> User.User
userFormData model =
    { id = -1
    , name = model.nameInput
    , email = model.emailInput
    , age = model.ageInput |> String.toInt |> Result.withDefault 0
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditUser id ->
            let
                user =
                    User.findUser id model.users
                        |> Maybe.withDefault User.nullUser
            in
                { model
                    | nameInput = user.name
                    , emailInput = user.email
                    , ageInput = toString user.age
                    , formAction = Edit
                    , selectedUser = Just id
                }
                    ! []

        DeleteUser id ->
            { model
                | formAction = Delete
                , selectedUser = Just id
            }
                ! [ User.Http.delete id ]

        NewUser ->
            { model
                | formAction = Create
                , nameInput = ""
                , emailInput = ""
                , ageInput = ""
                , selectedUser = Nothing
            }
                ! []

        ProcessUserGet (Ok users) ->
            { model
                | users = users
                , errors = Nothing
            }
                ! []

        ProcessUserGet (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserResponse (Ok user) ->
            { model | formAction = None } ! [ User.Http.get ]

        ProcessUserResponse (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        SetNameInput value ->
            { model | nameInput = value } ! []

        SetEmailInput value ->
            { model | emailInput = value } ! []

        SetAgeInput value ->
            { model | ageInput = value } ! []

        UserPost model ->
            model ! [ User.Http.post (userFormData model) ]

        UserPut model ->
            let
                id =
                    model.selectedUser |> Maybe.withDefault 0
            in
                model ! [ User.Http.put (userFormData model) id ]
