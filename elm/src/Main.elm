module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Utils


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { users : List User
    , nextUserId : Int
    }


type alias User =
    { id : Int
    , name : String
    , email : String
    , age : Int
    , stooge : String
    }


initUsers : List User
initUsers =
    [ User 1 "Joe" "joe@hello.com" 23 "moe"
    , User 2 "Jack" "jack@hello.com" 12 "larry"
    ]


init : ( Model, Cmd Msg )
init =
    { users = initUsers
    , nextUserId = 3
    }
        ! []



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []



-- View


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "row" ]
            [ userTable model.users
            , newUserForm
            ]
        ]


newUserForm : Html Msg
newUserForm =
    div [ class "col-md-3" ]
        [ Html.form []
            [ div [ class "form-group" ]
                [ label [] [ text "Name" ]
                , input [ class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Email" ]
                , input [ class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Age" ]
                , input [ class "form-control" ] []
                ]
            , div [ class "form-group" ]
                [ label [] [ text "Stooge" ]
                , input [ class "form-control" ] []
                ]
            , button [ class "btn btn-primary" ] [ text "Primary" ]
            ]
        ]


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
            [ th [] [ text "Name" ]
            , th [] [ text "Email" ]
            , th [] [ text "Age" ]
            , th [] [ text "Stooge" ]
            ]
        ]


userRows : List User -> List (Html Msg)
userRows users =
    users
        |> List.map userRow


userRow : User -> Html Msg
userRow user =
    tr []
        [ td [] [ text user.name ]
        , td [] [ text user.email ]
        , td [] [ text (toString user.age) ]
        , td [] [ text user.stooge ]
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
