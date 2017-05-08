module Main exposing (..)

import Html exposing (..)
import Model exposing (..)
import User.Http
import Update
import Subscriptions
import View


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init ! [ User.Http.get ]
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
