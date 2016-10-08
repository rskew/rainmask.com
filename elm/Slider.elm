module Slider exposing ( Model
                       , initialise
                       , Msg(UpdateValue)
                       , update
                       , view
                       )

import Utils exposing ( IntVector2
                      )


import Html exposing (Html, input, text, div)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String

-- MODEL

type alias Model =
  { name : String
  , value : Float
  , max : Float
  , min : Float
  , updateCommand : Float -> Cmd Msg
  , quant : Bool
  }

initialise : Model -> (Model, Cmd Msg)
initialise mdl =
  ( mdl
  , mdl.updateCommand mdl.value
  )


-- UPDATE

type Msg = UpdateValue String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateValue str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            let
              sliderVal = if model.quant then
                            quantise <| scaleSliderVal model num
                          else 
                            scaleSliderVal model num

            in
              ( { model | value = sliderVal }
              , model.updateCommand sliderVal
              )
          Err msg ->
            ( { model | value = 9999 }
            , Cmd.none
            )



-- VIEW

view : Model -> Html Msg
view model =
  let
    sliderStyle =
      [ 
        ("position" , "absolute")
      , ("left"     , "10px")
      , ("top"      , "40px")
      , ("width"    , "400px")
      , ("height"   , "10px")
      , ("border"   , "1px solid #FFFFFF")
      , ("background-color", "#303030")
      ]
    sliderHandleStyle =
      [ 
        ("position" , "absolute")
      , ("left"     , "410px")
      , ("top"      , "40px")
      , ("width"    , "40px")
      , ("height"   , "10px")
      , ("border"   , "1px solid #FFFFFF")
      , ("background-color", "#707070")
      ]
  in
    div []
      [ div []
          [ text model.name
          ]
      , div [ style [ ("position", "absolute")
                    , ("left", "10px")
                    ]
            ]
          [ text <| toString model.value
          ]
      , div []
          [ input
            [ type' "range"
            , Html.Attributes.min "0"
            , Html.Attributes.max <| toString sliderMax
            --, value <| toString <| round <| scaleValToSlider model model.value
            , value <| toString <| scaleValToSlider model model.value
            , onInput UpdateValue
            ] []
          ]
      , div [ style sliderStyle ]
          []
      , div [ style sliderHandleStyle ]
          []
      ]

sliderMax : Int
sliderMax = 1000

scaleSliderVal : Model -> Float -> Float
scaleSliderVal model val =
  val * ((model.max - model.min) / (toFloat sliderMax)) + model.min

scaleValToSlider : Model -> Float -> Float
scaleValToSlider model val =
  (val - model.min) * ((toFloat sliderMax) / (model.max - model.min))

quantisationRes : Int
quantisationRes = 2

quantise : Float -> Float
quantise flt =
  let
    q = toFloat quantisationRes
  in
    (*) q <| toFloat <| round <| flt / q
