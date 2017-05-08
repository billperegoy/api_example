module User.Http exposing (..)

import Http
import Json.Decode
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
