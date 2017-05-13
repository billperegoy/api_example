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


payload : User -> Json.Encode.Value
payload user =
    Json.Encode.object
        [ ( "name", Json.Encode.string user.name )
        , ( "email", Json.Encode.string user.email )
        , ( "age", Json.Encode.int user.age )
        ]


url : String
url =
    "http://localhost:4000/api/v1/users"


urlWithId : Int -> String
urlWithId id =
    url ++ "/" ++ (toString id)


get : Cmd Msg
get =
    Http.send ProcessUserListResponse (Http.get url listDecoder)


post : User -> Cmd Msg
post user =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))
    in
        Http.send ProcessUserResponse (Http.post url body decoder)


put : User -> Int -> Cmd Msg
put user id =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))

        request =
            Http.request
                { method = "PUT"
                , headers = []
                , url = urlWithId id
                , body = body
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ProcessUserResponse request


delete : Int -> Cmd Msg
delete id =
    let
        request =
            Http.request
                { method = "DELETE"
                , headers = []
                , url = urlWithId id
                , body = Http.emptyBody
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ProcessUserResponse request
