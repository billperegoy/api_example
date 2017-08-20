module User exposing (..)

import Error


type UserHttpResponse
    = UserNoResponse
    | ValidUserResponse User
    | ErrorUserResponse (List Error.Error)


type UserListHttpResponse
    = UserListNoResponse
    | ValidUserListResponse (List User)
    | ErrorUserListResponse (List Error.Error)


type alias UserResponse =
    { data : User
    }


type alias UserListResponse =
    { data : List User
    }


type alias User =
    { id : Int
    , name : String
    , email : String
    , age : Int
    }


nullUser : User
nullUser =
    { id = -1
    , name = ""
    , email = ""
    , age = 0
    }


findUser : Int -> List User -> Maybe User
findUser id users =
    users
        |> List.filter (\user -> user.id == id)
        |> List.head
