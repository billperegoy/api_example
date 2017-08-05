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
        ShowUpdateUserForm id ->
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
                    , errors = Nothing
                }
                    ! []

        ShowDeleteUserForm id ->
            { model
                | formAction = Delete
                , selectedUser = Just id
                , errors = Nothing
            }
                ! []

        ShowCreateUserForm ->
            { model
                | formAction = Create
                , nameInput = ""
                , emailInput = ""
                , ageInput = ""
                , selectedUser = Nothing
                , errors = Nothing
            }
                ! []

        ProcessUserListResponse (Ok userResponse) ->
            let
                users =
                    userResponse.data
            in
                { model
                    | users = users
                    , errors = Nothing
                }
                    ! []

        ProcessUserListResponse (Err error) ->
            { model
                | errors = Just error
            }
                ! []

        ProcessUserResponse (Ok userResponse) ->
            { model | formAction = None } ! [ User.Http.get ]

        ProcessUserResponse (Err error) ->
            { model | errors = Just error } ! []

        SetNameInput value ->
            { model | nameInput = value } ! []

        SetEmailInput value ->
            { model | emailInput = value } ! []

        SetAgeInput value ->
            { model | ageInput = value } ! []

        CreateUser model ->
            model ! [ User.Http.post (userFormData model) ]

        UpdateUser model ->
            let
                id =
                    model.selectedUser |> Maybe.withDefault 0
            in
                model ! [ User.Http.put (userFormData model) id ]

        DeleteUser model ->
            let
                id =
                    model.selectedUser |> Maybe.withDefault 0
            in
                model ! [ User.Http.delete id ]
