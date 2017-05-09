module Http.Utils exposing (..)

import Html
import Html.Events exposing (..)
import Json.Decode


onClickNoDefault : msg -> Html.Attribute msg
onClickNoDefault message =
    let
        config =
            { stopPropagation = True
            , preventDefault = True
            }
    in
        onWithOptions "click" config (Json.Decode.succeed message)
