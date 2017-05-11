module User exposing (..)


type alias User =
    { id : Int
    , name : String
    , email : String
    , age : Int
    , stooge : String
    }


nullUser : User
nullUser =
    { id = -1
    , name = ""
    , email = ""
    , age = 0
    , stooge = ""
    }


findUser : Int -> List User -> Maybe User
findUser id users =
    users
        |> List.filter (\user -> user.id == id)
        |> List.head
