module Error.Http exposing (..)

import Http
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline
import Model exposing (..)
import Error exposing (..)
import User exposing (..)


errorResponseDecoder : Json.Decode.Decoder ErrorResponse
errorResponseDecoder =
    Json.Decode.Pipeline.decode ErrorResponse
        |> Json.Decode.Pipeline.required "errors" listDecoder


listDecoder : Json.Decode.Decoder (List Error)
listDecoder =
    Json.Decode.list decoder


decoder : Json.Decode.Decoder Error
decoder =
    Json.Decode.Pipeline.decode Error
        |> Json.Decode.Pipeline.required "key" Json.Decode.string
        |> Json.Decode.Pipeline.required "value" Json.Decode.string
