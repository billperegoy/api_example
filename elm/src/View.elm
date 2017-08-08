module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)
import User exposing (..)
import Http.Utils


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ button
                [ onClick ShowCreateUserForm, class "button btn-primary" ]
                [ text "New User" ]
            ]
        , div [ class "row" ]
            [ userTable model.users
            , formColumn model
            ]
        ]


formColumn : Model -> Html Msg
formColumn model =
    let
        innerForm =
            if model.formAction == Create || model.formAction == Edit then
                userForm model
            else if model.formAction == Delete then
                deleteForm model
            else
                div [] []
    in
        div [ class "col-md-3" ]
            [ innerForm ]


fieldStringValue : Maybe User -> FormAction -> (User -> String) -> String
fieldStringValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user
            else
                ""

        Nothing ->
            ""


fieldIntValue : Maybe User -> FormAction -> (User -> Int) -> String
fieldIntValue user formAction extractor =
    case user of
        Just user ->
            if formAction == Edit then
                extractor user |> toString
            else
                ""

        Nothing ->
            ""


userForm : Model -> Html Msg
userForm model =
    let
        user =
            case model.selectedUser of
                Just id ->
                    User.findUser id model.users

                Nothing ->
                    Nothing

        name =
            fieldStringValue user model.formAction .name

        email =
            fieldStringValue user model.formAction .email

        age =
            fieldIntValue user model.formAction .age

        buttonText =
            if model.formAction == Edit then
                "Update"
            else
                "Create"

        buttonAction =
            if model.formAction == Edit then
                UpdateUser model
            else
                CreateUser model

        errorAlert =
            case model.errors of
                Just _ ->
                    div
                        [ class "alert alert-danger" ]
                        [ text ("Invalid data. Try again." ++ (toString model.errors)) ]

                Nothing ->
                    div [] []
    in
        Html.form []
            [ errorAlert
            , div [ class "form-group" ]
                [ label [] [ text "Name" ]
                , input [ onInput SetNameInput, value model.nameInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Email" ]
                , input [ onInput SetEmailInput, value model.emailInput, class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Age" ]
                , input [ onInput SetAgeInput, value model.ageInput, class "form-control" ] []
                ]
            , button [ Http.Utils.onClickNoDefault buttonAction, class "btn btn-primary" ] [ text buttonText ]
            ]


deleteForm : Model -> Html Msg
deleteForm model =
    Html.form []
        [ button [ Http.Utils.onClickNoDefault (DeleteUser model), class "btn btn-primary" ] [ text "Are you sure?" ] ]


userTable : List User -> Html Msg
userTable users =
    div [ class "col-md-9" ]
        [ table
            [ class "table table-striped" ]
            [ userTableHeader
            , tbody [] (userRows users)
            ]
        ]


userTableHeader : Html Msg
userTableHeader =
    thead []
        [ tr []
            [ th [ colspan 2 ] []
            , th [] [ text "Name" ]
            , th [] [ text "Email" ]
            , th [] [ text "Age" ]
            ]
        ]


userRows : List User -> List (Html Msg)
userRows users =
    users
        |> List.map userRow


actionButton : Msg -> String -> Html Msg
actionButton msg textValue =
    button
        [ onClick msg, class "button btn-primary" ]
        [ text textValue ]


userRow : User -> Html Msg
userRow user =
    tr []
        [ td [] [ actionButton (ShowUpdateUserForm user.id) "Edit" ]
        , td [] [ actionButton (ShowDeleteUserForm user.id) "Delete" ]
        , td [] [ text user.name ]
        , td [] [ text user.email ]
        , td [] [ text (toString user.age) ]
        ]
