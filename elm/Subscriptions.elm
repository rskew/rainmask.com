port module Subscriptions exposing (subscriptions)

import Model exposing (Model)
import Update exposing (Msg (..))
import Utils exposing (Time)

--import Time exposing (millisecond)

port timerPort : (Time -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
    timerPort GenerateDrop 
