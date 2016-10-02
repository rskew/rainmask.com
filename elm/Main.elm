module Main exposing (..)

--import Model exposing (init)
import View exposing (view)
import Update exposing ( update
                       , init
                       )
import Subscriptions exposing (subscriptions)

import Html.App as App

main =
  App.program { init = init, view = view, update = update, subscriptions = subscriptions }
