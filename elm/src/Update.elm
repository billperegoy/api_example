module Update exposing (..)

import Model exposing (..)
import User.Http
import View


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        EditUser id ->
            let
                user =
                    View.findUser id model.users

                name =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.name

                email =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.email

                age =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.age |> toString

                stooge =
                    case user of
                        Nothing ->
                            "huh?"

                        Just u ->
                            u.stooge
            in
                { model
                    | nameInput = name
                    , emailInput = email
                    , ageInput = age
                    , stoogeInput = stooge
                    , formAction = Edit
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
