port module Subscriptions exposing (subscriptions)

import Model exposing (Model)
import Update exposing (Msg (..))

import Time exposing (millisecond)

port timerPort : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    timerPort GenerateDrop 
