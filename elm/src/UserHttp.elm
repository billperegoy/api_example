module User.Http exposing (..)

import Http
import Html.Events exposing (..)
import Html
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


url : String
url =
    "http://localhost:4000/api/v1/users"


get : Cmd Msg
get =
    Http.send ProcessUserGet (Http.get url listDecoder)


post : Model -> Cmd Msg
post model =
    let
        age =
            model.ageInput
                |> String.toInt
                |> Result.withDefault 0

        payload =
            Json.Encode.object
                [ ( "name", Json.Encode.string model.nameInput )
                , ( "email", Json.Encode.string model.emailInput )
                , ( "age", Json.Encode.int age )
                , ( "stooge", Json.Encode.string model.stoogeInput )
                ]

        body =
            Http.stringBody "application/json" (Json.Encode.encode 0 payload)
    in
        Http.send ProcessUserPost (Http.post url body decoder)
