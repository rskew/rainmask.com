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
  let
    margin = { x = 30, y = 30 }
  in
    div [ style [ ("position", "absolute")
                , ("left", toString margin.x)
                , ("top", toString margin.y)
                ]
        ]
      [ div []
          [ Html.App.map SliderChange <| Sliders.view model.sliders
          ]
      , div [ style [ ("position", "absolute")
                    , ("left", "320px")
                    ]
            ]
          [ button [ onClick ToggleOnOff ] [ text "Rain On/Off" ]
          ]
      ]
