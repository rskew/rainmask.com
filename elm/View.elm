module View exposing (view)

import Model exposing (Model)
import Update exposing ( Msg (..)
                       , sliderMargin
                       )
import Sliders

import Html exposing (Html, Attribute, div, node, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App
import String


view : Model -> Html Msg
view model =
  div [ style [ ("position", "absolute")
              , ("left", toString sliderMargin.x)
              , ("top", toString sliderMargin.y)
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
    , div [ style [ ("position", "absolute")
                  , ("left", "320px")
                  , ("top", "40px")
                  ]
          ]
        [ Html.a [ href "http://www.github.com/rskew/rainmask.com"
            , target "_blank"
            ]
            [ text "Source"
            ]
        ]
    ]
