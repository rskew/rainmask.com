module Slider exposing ( Model
                       , initialise
                       , Msg(..)
                       , update
                       , view
                       )

import Utils exposing ( IntVector2
                      , ContainerSize
                      )


import Html exposing (Html, input, text, div)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Mouse

-- MODEL

type alias Model =
  { name : String
  , value : Float
  , max : Float
  , min : Float
  , updateCommand : Float -> Cmd Msg
  , quant : Bool
  , containerSize : ContainerSize
  , grabbed : Bool
  , mousePos : IntVector2
  }

initialise : Model -> (Model, Cmd Msg)
initialise mdl =
  ( mdl
  , mdl.updateCommand mdl.value
  )


-- UPDATE

type Msg
  = UpdateValue  Float
  | MouseMove    IntVector2
  | MouseUp      IntVector2
  | MouseDown    IntVector2
  | ResizeWindow ContainerSize


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateValue float ->
      let
        newVal = if model.quant then
                   quantise float
                 else 
                   float
      in
        ( { model | value = newVal }
        , model.updateCommand newVal
        )
      
    MouseMove pos ->
      case model.grabbed of
        True ->
          let
            scalePixelToVal = (model.max - model.min) / (toFloat (model.containerSize.width - 50))
            inputVal = Basics.max (Basics.min (model.value + scalePixelToVal * 
                                                (toFloat (pos.x - model.mousePos.x)))
                                            model.max)
                                model.min
            newVal = if model.quant then
                       quantise inputVal
                     else
                       inputVal
          in
            --update (UpdateValue newVal) model
            ( { model | value = newVal
                      , mousePos = pos
                      }
            , model.updateCommand newVal
            )
        False ->
          ( model
          , Cmd.none
          )

    MouseDown pos ->
      if isOnSlider pos model then
        ( { model | grabbed = True
                  , mousePos = pos }
        , Cmd.none
        )
      else
        ( model
        , Cmd.none
        )

    MouseUp pos ->
      ( { model | grabbed = False }
      , Cmd.none
      )

    ResizeWindow newSize ->
      ( { model | containerSize = newSize }
      , Cmd.none
      )


isOnSlider : IntVector2 -> Model -> Bool
isOnSlider pos model =
  if pos.x > 8 && pos.x < 
                    (round ((model.value/model.max) * (toFloat (model.containerSize.width - 50))) + 52)
        && pos.y > 58 && pos.y < 72 then
    True
  else
    False

-- VIEW

view : Model -> Html Msg
view model =
  let
    sliderStyle =
      [ 
        ("position" , "absolute")
      , ("left"     , "10px")
      , ("top"      , "60px")
      --, ("width"    , toString (model.containerSize.width - 10) ++ "px")
      , ("width"    , (toString <|
                           round ((model.value/model.max) * (toFloat (model.containerSize.width - 50))) + 10)
                      ++ "px")
      , ("height"   , "10px")
      , ("border"   , "1px solid #FFFFFF")
      , ("background-color", "#303030")
      ]
    sliderHandleStyle =
      [ 
        ("position" , "absolute")
      , ("left"     , (toString <|
                        round ((model.value/model.max) * (toFloat (model.containerSize.width - 50))) + 10)
                       ++ "px")
      , ("top"      , "60px")
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
      , div [ style sliderStyle ]
          []
      , div [ style sliderHandleStyle ]
          []
      ]

quantisationRes : Int
quantisationRes = 1

quantise : Float -> Float
quantise flt =
  let
    q = toFloat quantisationRes
  in
    (*) q <| toFloat <| round <| flt / q
