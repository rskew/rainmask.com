port module Subscriptions exposing (subscriptions)

import Model exposing (Model)
import Update exposing (Msg (..))
import Utils exposing ( WebAudioTime
                      , JSTime
                      )

import Mouse
import Window

--import Time exposing (millisecond)

port timerPort : (WebAudioTime -> msg) -> Sub msg

port visibilityPort : (Bool -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ timerPort ScheduleDrops
    , visibilityPort VisibilityChange
    , Mouse.moves MouseMove
    , Mouse.downs MouseDown
    , Mouse.ups MouseUp
    , Window.resizes ResizeWindow
    ]
