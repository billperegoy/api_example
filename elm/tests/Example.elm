module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Json.Decode
import User exposing (..)
import User.Http
import Error exposing (..)
import Error.Http


suite : Test
suite =
    describe "A Test Suite"
        [ test "Decodes a valid error" <|
            \() ->
                let
                    json =
                        """
                          { "key" : "age", "value" : "must be greater than 17" }
                        """

                    decodedOutput =
                        Json.Decode.decodeString Error.Http.decoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok (Error "age" "must be greater than 17"))
          --
          --
        , test "Decodes a valid error list " <|
            \() ->
                let
                    json =
                        """
                        [
                          { "key" : "age", "value" : "must be greater than 17" },
                          { "key" : "name", "value" : "must be at least 12 characters" }
                        ]
                        """

                    decodedOutput =
                        Json.Decode.decodeString Error.Http.listDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            [ Error "age" "must be greater than 17"
                            , Error "name" "must be at least 12 characters"
                            ]
                        )
          --
          --
        , test "Decodes a valid error list response" <|
            \() ->
                let
                    json =
                        """
                                    { "errors" :
                                        [
                                          { "key" : "age", "value" : "must be greater than 17" },
                                          { "key" : "name", "value" : "must be at least 12 characters" }
                                        ]
                                    }
                             """

                    decodedOutput =
                        Json.Decode.decodeString Error.Http.errorResponseDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            { errors =
                                [ Error "age" "must be greater than 17"
                                , Error "name" "must be at least 12 characters"
                                ]
                            }
                        )
          --
          --
        , test "Decodes a valid error list response into a union type" <|
            \() ->
                let
                    json =
                        """
                                         { "errors" :
                                             [
                                               { "key" : "age", "value" : "must be greater than 17" },
                                               { "key" : "name", "value" : "must be at least 12 characters" }
                                             ]
                                         }
                                  """

                    decodedOutput =
                        Json.Decode.decodeString User.Http.userHttpResponseDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            (ErrorUserResponse
                                [ Error "age" "must be greater than 17"
                                , Error "name" "must be at least 12 characters"
                                ]
                            )
                        )
          --
          --
        , test "Decodes a valid user" <|
            \() ->
                let
                    json =
                        """
                          { "id" : 1,
                            "name" : "Joe",
                            "email" : "joe@example.com",
                            "age" : 43
                          }
                        """

                    decodedOutput =
                        Json.Decode.decodeString User.Http.decoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok (User 1 "Joe" "joe@example.com" 43))
          --
          --
        , test "Decodes a valid user list" <|
            \() ->
                let
                    json =
                        """
                            [
                                {
                                    "updated_at": "2017-08-07T22:14:35.306460",
                                    "name": "Kit-Sheep-the-best",
                                    "inserted_at": "2017-07-31T22:36:51.030531",
                                    "id": 1,
                                    "email": "kitSheep@critters.com",
                                    "age": 40
                                },
                                {
                                    "updated_at": "2017-08-05T20:52:22.879667",
                                    "name": "Kitty Kitty Kitty",
                                    "inserted_at": "2017-07-31T22:37:04.111669",
                                    "id": 2,
                                    "email": "kit@cat.com",
                                    "age": 14
                                }
                            ]
                        """

                    decodedOutput =
                        Json.Decode.decodeString User.Http.listDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            [ { name = "Kit-Sheep-the-best"
                              , email = "kitSheep@critters.com"
                              , age = 40
                              , id = 1
                              }
                            , { name = "Kitty Kitty Kitty"
                              , email = "kit@cat.com"
                              , age = 14
                              , id = 2
                              }
                            ]
                        )
          --
          --
        , test "Decodes a valid user list response" <|
            \() ->
                let
                    json =
                        """
                        { "data" :
                            [
                                {
                                    "updated_at": "2017-08-07T22:14:35.306460",
                                    "name": "Kit-Sheep-the-best",
                                    "inserted_at": "2017-07-31T22:36:51.030531",
                                    "id": 1,
                                    "email": "kitSheep@critters.com",
                                    "age": 40
                                },
                                {
                                    "updated_at": "2017-08-05T20:52:22.879667",
                                    "name": "Kitty Kitty Kitty",
                                    "inserted_at": "2017-07-31T22:37:04.111669",
                                    "id": 2,
                                    "email": "kit@cat.com",
                                    "age": 14
                                }
                            ]
                        }
                        """

                    decodedOutput =
                        Json.Decode.decodeString User.Http.listResponseDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            { data =
                                [ { name = "Kit-Sheep-the-best"
                                  , email = "kitSheep@critters.com"
                                  , age = 40
                                  , id = 1
                                  }
                                , { name = "Kitty Kitty Kitty"
                                  , email = "kit@cat.com"
                                  , age = 14
                                  , id = 2
                                  }
                                ]
                            }
                        )
          --
          --
        , test "Decodes a valid user list to union type" <|
            \() ->
                let
                    json =
                        """
                        { "data" :
                            [
                                {
                                    "updated_at": "2017-08-07T22:14:35.306460",
                                    "name": "Kit-Sheep-the-best",
                                    "inserted_at": "2017-07-31T22:36:51.030531",
                                    "id": 1,
                                    "email": "kitSheep@critters.com",
                                    "age": 40
                                },
                                {
                                    "updated_at": "2017-08-05T20:52:22.879667",
                                    "name": "Kitty Kitty Kitty",
                                    "inserted_at": "2017-07-31T22:37:04.111669",
                                    "id": 2,
                                    "email": "kit@cat.com",
                                    "age": 14
                                }
                            ]
                        }
                        """

                    decodedOutput =
                        Json.Decode.decodeString User.Http.userHttpResponseDecoder json
                in
                    Expect.equal
                        decodedOutput
                        (Ok
                            (ValidUserResponse
                                [ { name = "Kit-Sheep-the-best"
                                  , email = "kitSheep@critters.com"
                                  , age = 40
                                  , id = 1
                                  }
                                , { name = "Kitty Kitty Kitty"
                                  , email = "kit@cat.com"
                                  , age = 14
                                  , id = 2
                                  }
                                ]
                            )
                        )
        ]
