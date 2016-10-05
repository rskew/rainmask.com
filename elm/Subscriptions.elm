port module Subscriptions exposing (subscriptions)

import Model exposing (Model)
import Update exposing (Msg (..))
import Utils exposing ( WATime
                      , JSTime
                      )

--import Time exposing (millisecond)

port timerPort : (JSTime -> msg) -> Sub msg

port visibilityPort : (Bool -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ timerPort ScheduleDrops
    , visibilityPort VisibilityChange
    ]
