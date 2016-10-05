module View exposing (view)

import Model exposing (Model)
import Update exposing ( Msg (..)
                       )
import Sliders

import Html exposing (Html, Attribute, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App
import String


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick ToggleOnOff ] [ text "Rain On/Off" ]
    , Html.App.map SliderChange <| Sliders.view model.sliders
    ]
