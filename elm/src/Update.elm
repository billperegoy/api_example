module Update exposing (..)

import Model exposing (..)
import User
import User.Http


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

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
                    , stoogeInput = user.stooge
                    , formAction = Edit
                    , selectedUser = Just id
                }
                    ! []

        DeleteUser id ->
            { model
                | formAction = Delete
                , selectedUser = Just id
            }
                ! [ User.Http.delete { model | selectedUser = Just id } ]

        NewUser ->
            { model
                | formAction = Create
                , nameInput = ""
                , emailInput = ""
                , ageInput = ""
                , stoogeInput = ""
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

        SetStoogeInput value ->
            { model | stoogeInput = value } ! []

        UserPost model ->
            model ! [ User.Http.post model ]

        UserPut model ->
            model ! [ User.Http.put model ]
