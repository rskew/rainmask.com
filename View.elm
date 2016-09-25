module View exposing (view)

import Model exposing (Model)
import Update exposing (Msg (..))

import Html exposing (Html, Attribute, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick ToggleOnOff ] [ text "Rain On/Off" ]
    , div []
        [ text <| "Decay Time: " ++ toString model.decayTime
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "4000"
            , value <| toString <| round <| 1000 * model.decayTime
            , onInput UpdateDecay
            ] []
          ]
    , div []
        [ text <| "Rain Intensity: " ++ toString model.rainIntensity
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "300"
            , value <| toString model.rainIntensity
            , onInput UpdateIntensity
            ] []
          ]
    , div []
        [ text <| "Background Noise Level: " ++ toString model.backgroundNoiseLevel
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "100"
            , value <| toString <| round <| 100 * model.backgroundNoiseLevel
            , onInput BackgroundNoiseLevel
            ] []
          ]
    , div []
        [ text <| "Dry Level: " ++ toString model.dryLevel
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "100"
            , value <| toString <| round <| 100 * model.dryLevel
            , onInput DryLevel
            ] []
          ]
    , div []
        [ text <| "Reverb Level: " ++ toString model.reverbLevel
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "100"
            , value <| toString <| round <| 100 * model.reverbLevel
            , onInput ReverbLevel
            ] []
          ]
    , div []
        [ text <| "Master Volume: " ++ toString model.masterVolume
        ]
    , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max "100"
            , value <| toString <| round <| 100 * model.masterVolume
            , onInput MasterVolume
            ] []
          ]
    ]
