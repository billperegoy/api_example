module User exposing (..)


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
