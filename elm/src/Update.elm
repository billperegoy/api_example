module Update exposing (..)

import Model exposing (..)
import User.Http


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        EditUser id ->
            { model
                | formAction = Edit
                , selectedUser = Just id
            }
                ! []

        DeleteUser id ->
            { model
                | formAction = Delete
                , selectedUser = Just id
            }
                ! []

        NewUser ->
            { model
                | formAction = Create
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

        ProcessUserPost (Ok user) ->
            { model | formAction = None } ! [ User.Http.get ]

        ProcessUserPost (Err error) ->
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
