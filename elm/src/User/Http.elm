module User.Http exposing (..)

import Http
import Json.Decode
import Json.Encode
import Json.Decode.Pipeline
import Model exposing (..)
import User exposing (..)
import Error.Http


{-
   This is how I figured out how to decode
   https://stackoverflow.com/questions/41969381/how-do-i-json-decode-a-union-type
-}


validUsersDecoder : Json.Decode.Decoder UserListHttpResponse
validUsersDecoder =
    Json.Decode.map (\response -> ValidUserListResponse response.data) listResponseDecoder


errorUsersDecoder : Json.Decode.Decoder UserListHttpResponse
errorUsersDecoder =
    Json.Decode.map (\response -> ErrorUserListResponse response.errors) Error.Http.errorResponseDecoder


userHttpResponseDecoder : Json.Decode.Decoder UserListHttpResponse
userHttpResponseDecoder =
    Json.Decode.oneOf
        [ validUsersDecoder
        , errorUsersDecoder
        ]


responseDecoder : Json.Decode.Decoder UserResponse
responseDecoder =
    Json.Decode.Pipeline.decode UserResponse
        |> Json.Decode.Pipeline.required "data" decoder


listResponseDecoder : Json.Decode.Decoder UserListResponse
listResponseDecoder =
    Json.Decode.Pipeline.decode UserListResponse
        |> Json.Decode.Pipeline.required "data" listDecoder


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
    Http.send ProcessUserListResponse (Http.get url listResponseDecoder)


post : User -> Cmd Msg
post user =
    let
        body =
            Http.stringBody "application/json"
                (Json.Encode.encode 0 (payload user))
    in
        Http.send ProcessUserResponse (Http.post url body responseDecoder)


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
                , expect = Http.expectJson responseDecoder
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
                , expect = Http.expectJson responseDecoder
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send ProcessUserResponse request
