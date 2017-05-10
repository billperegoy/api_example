module User.Http exposing (delete, get, post, put)

import Http
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline
import Model exposing (..)
import User exposing (..)


listDecoder : Json.Decode.Decoder (List User)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder User
decoder =
    Json.Decode.Pipeline.decode User
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "age" Json.Decode.int
        |> Json.Decode.Pipeline.required "stooge" Json.Decode.string


baseUrl : String
baseUrl =
    "http://localhost:4000/api/v1/users"


userUrl : Maybe Int -> String
userUrl maybeId =
    case maybeId of
        Nothing ->
            Debug.crash "Received Nothing for user id"

        Just id ->
            baseUrl ++ "/" ++ (toString id)


payload : Model -> Json.Encode.Value
payload model =
    let
        age =
            model.ageInput
                |> String.toInt
                |> Result.withDefault 0
    in
        Json.Encode.object
            [ ( "name", Json.Encode.string model.nameInput )
            , ( "email", Json.Encode.string model.emailInput )
            , ( "age", Json.Encode.int age )
            , ( "stooge", Json.Encode.string model.stoogeInput )
            ]


get : Cmd Msg
get =
    Http.send ProcessUserGet (Http.get baseUrl listDecoder)


post : Model -> Cmd Msg
post model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))
    in
        Http.send ProcessUserResponse (Http.post baseUrl body decoder)


put : Model -> Cmd Msg
put model =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload model))

        request =
            Http.request
                { method = "PUT"
                , headers = []
                , url = (userUrl model.selectedUser)
                , body = body
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ProcessUserResponse request


delete : Model -> Cmd Msg
delete model =
    let
        request =
            Http.request
                { method = "DELETE"
                , headers = []
                , url = (userUrl model.selectedUser)
                , body = Http.emptyBody
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ProcessUserResponse request
