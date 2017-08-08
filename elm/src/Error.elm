module Error exposing (..)


type alias ErrorResponse =
    { errors : List Error
    }


type alias Error =
    { key : String
    , value : String
    }
