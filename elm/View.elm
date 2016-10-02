module View exposing (view)

import Model exposing (Model)
import Update exposing ( Msg (..)
                       , SliderMsg (..)
                       )
import Slider

import Html exposing (Html, Attribute, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Html.App
import String


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick ToggleOnOff ] [ text "Rain On/Off" ]
    , Html.App.map (SliderChange << DecayTime)            <| Slider.view model.sliders.decayTime
    , Html.App.map (SliderChange << RainIntensity)        <| Slider.view model.sliders.rainIntensity
    , Html.App.map (SliderChange << BackgroundNoiseLevel) <| Slider.view model.sliders.backgroundNoiseLevel
    , Html.App.map (SliderChange << DropLevel)            <| Slider.view model.sliders.dropLevel
    , Html.App.map (SliderChange << ReverbLevel)          <| Slider.view model.sliders.reverbLevel
    , Html.App.map (SliderChange << MasterVolume)         <| Slider.view model.sliders.masterVolume
    ]
--   , div []
--       [ text <| "Decay Time: " ++ toString model.decayTime
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "4000"
--           , value <| toString <| round <| 1000 * model.decayTime
--           , onInput <| SliderChange << DecayTime
--           ] []
--         ]
--   , div []
--       [ text <| "Rain Intensity: " ++ toString model.rainIntensity
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "300"
--           , value <| toString model.rainIntensity
--           , onInput <| SliderChange << RainIntensity
--           ] []
--         ]
--   , div []
--       [ text <| "Background Noise Level: " ++ toString model.backgroundNoiseLevel
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "100"
--           , value <| toString <| round <| 100 * model.backgroundNoiseLevel
--           , onInput <| SliderChange << BackgroundNoiseLevel
--           ] []
--         ]
--   , div []
--       [ text <| "Raindrop Level: " ++ toString model.dropLevel
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "100"
--           , value <| toString <| round <| 100 * model.dropLevel
--           , onInput <| SliderChange << DropLevel
--           ] []
--         ]
--   , div []
--       [ text <| "Reverb Level: " ++ toString model.reverbLevel
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "100"
--           , value <| toString <| round <| 100 * model.reverbLevel
--           , onInput <| SliderChange << ReverbLevel
--           ] []
--         ]
--   , div []
--       [ text <| "Master Volume: " ++ toString model.masterVolume
--       ]
--   , div []
--         [ input
--           [ type' "range"
--           , Html.Attributes.min "0"
--           , Html.Attributes.max "100"
--           , value <| toString <| round <| 100 * model.masterVolume
--           , onInput <| SliderChange << MasterVolume
--           ] []
--         ]
--    ]
--
--type alias SliderParams =
--  { name : String
--  , modelAccessor : Model -> Float
--  , initValue : Float
--  , max : Float
--  , min : Float
--  , updateCommand : Float -> Cmd Msg
--  , quant : Bool
--  }
--
--slider : SliderParams -> Html Msg
--slider { name, modelAccessor, initValue, max, min, updateCommand, quant } =
--  div []
--    [ div []
--        [ text <| str ++ toString modelParameter
--        ]
--    , div []
--        [ input
--          [ type' "range"
--          , Html.Attributes.min "0"
--          , Html.Attributes.max "100"
--          , value <| toString <| round <| 100 * modelParameter
--          , onInput msg
--          ] []
--        ]
--    ]
