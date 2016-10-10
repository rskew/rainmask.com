module Sliders exposing ( Model
                        , init
                        , Msg(..)
                        , update
                        , view
                        )

import Slider
import Cmds
import Utils exposing ( IntVector2
                      , ContainerSize
                      )

import Html exposing (Html, div)
import Html.App
import Html.Attributes exposing (style)
import Mouse exposing ( position
                      , ups
                      , downs
                      )
                          
-- MODEL

type alias Model =
  { decayTime : Slider.Model
  , rainIntensity : Slider.Model
  , backgroundNoiseLevel : Slider.Model
  , dropLevel : Slider.Model
  , reverbLevel : Slider.Model
  , masterVolume : Slider.Model
  , activeSlider: Maybe SliderHandle
  , containerSize : ContainerSize
  }

type SliderHandle =
  SliderHandle
    { getter : Model -> Slider.Model
    , setter : Model -> Slider.Model -> Model
    , msg : Slider.Msg -> Msg
    , relativePos : IntVector2
    }


init : ContainerSize -> ( Model, Cmd Msg )
init size =
  let
    ( decayTimeSlider, decayTimeInitCmd ) =
        Slider.initialise { name = "Decay Time"
                          , value = 1.78
                          , max = 4
                          , min = 0.001
                          , updateCommand = \n -> Cmd.none
                          , quant = False
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
    ( rainIntensitySlider, rainIntensityInitCmd) =
        Slider.initialise { name = "Rain Intensity"
                          --, value = 60
                          , value = 30
                          , max = 200
                          , min = 1
                          , updateCommand = \n -> Cmd.none
                          , quant = True
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
    ( backgroundNoiseLevelSlider, backgroundNoiseLevelInitCmd ) =
        Slider.initialise { name = "Background Noise Level"
                          , value = 0.20
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.backgroundNoiseLevelPort
                          , quant = False
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
    ( dropLevelSlider, dropLevelInitCmd ) =
        Slider.initialise { name = "Raindrop Level"
                          , value = 1
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.dropLevelPort
                          , quant = False
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
    ( reverbLevelSlider, reverbLevelInitCmd ) =
        Slider.initialise { name = "Reverb Level"
                          , value = 0.4
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.reverbLevelPort
                          , quant = False
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
    ( masterVolumeSlider, masterVolumeInitCmd ) =
        Slider.initialise { name = "Master Volume"
                          , value = 1
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.masterVolumePort
                          , quant = False
                          , containerSize = { height = 70, width = size.width }
                          , grabbed = False
                          , mousePos = { x = 0, y = 0 }
                          }
  in
    ( { decayTime = decayTimeSlider
      , rainIntensity = rainIntensitySlider
      , backgroundNoiseLevel = backgroundNoiseLevelSlider
      , dropLevel = dropLevelSlider
      , reverbLevel = reverbLevelSlider
      , masterVolume = masterVolumeSlider
      , activeSlider = Nothing
      , containerSize = size
      }
    , Cmd.batch [ Cmd.map DecayTime decayTimeInitCmd
                , Cmd.map RainIntensity rainIntensityInitCmd
                , Cmd.map BackgroundNoiseLevel backgroundNoiseLevelInitCmd
                , Cmd.map DropLevel dropLevelInitCmd
                , Cmd.map ReverbLevel reverbLevelInitCmd
                , Cmd.map MasterVolume masterVolumeInitCmd
                ]
    )




-- UPDATE

type Msg
  = DecayTime               Slider.Msg
  | RainIntensity           Slider.Msg
  | BackgroundNoiseLevel    Slider.Msg
  | DropLevel               Slider.Msg
  | ReverbLevel             Slider.Msg
  | MasterVolume            Slider.Msg
  | MouseMove               IntVector2
  | MouseUp                 IntVector2
  | MouseDown               IntVector2
  | ResizeWindow            ContainerSize


update : Msg -> Model -> (Model, Cmd Msg)
update sliderMsg model =
  case sliderMsg of
    DecayTime subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.decayTime
      in
        ( { model | decayTime = updatedSliderModel }
        , Cmd.map DecayTime sliderCmd
        )

    RainIntensity subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.rainIntensity
      in
        ( { model | rainIntensity = updatedSliderModel }
        , Cmd.map RainIntensity sliderCmd
        )

    BackgroundNoiseLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.backgroundNoiseLevel
      in
        ( { model | backgroundNoiseLevel = updatedSliderModel }
        , Cmd.map BackgroundNoiseLevel sliderCmd
        )

    DropLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.dropLevel
      in
        ( { model | dropLevel = updatedSliderModel }
        , Cmd.map DropLevel sliderCmd
        )

    ReverbLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.reverbLevel
      in
        ( { model | reverbLevel = updatedSliderModel }
        , Cmd.map ReverbLevel sliderCmd
        )

    MasterVolume subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg model.masterVolume
      in
        ( { model | masterVolume = updatedSliderModel }
        , Cmd.map MasterVolume sliderCmd
        )

    MouseMove pos ->
      handleMouseMove pos model

    MouseDown pos ->
      handleMouseDown pos model

    MouseUp pos ->
      handleMouseUp pos model

    ResizeWindow size ->
      ( model
      , Cmd.none
      )


handleMouseMove : IntVector2 -> Model -> (Model, Cmd Msg)
handleMouseMove pos model =
  case model.activeSlider of
    Just (SliderHandle sliderHandle) ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update (Slider.MouseMove <| relativePos pos (SliderHandle sliderHandle))
                          (sliderHandle.getter model)
      in
        ( sliderHandle.setter model updatedSliderModel
        , Cmd.map sliderHandle.msg sliderCmd
        )
    Nothing ->
      ( model
      , Cmd.none
      )

relativePos : IntVector2 -> SliderHandle -> IntVector2
relativePos pos (SliderHandle sliderHandle) =
    { x = pos.x - sliderHandle.relativePos.x
    , y = pos.y - sliderHandle.relativePos.y
    }


handleMouseDown : IntVector2 -> Model -> (Model, Cmd Msg)
handleMouseDown pos model =
  let
    sliderHandleWrapped = mouseOverWhichSlider pos model
  in
    case sliderHandleWrapped of
      Just (SliderHandle sliderHandle) ->
        let
          ( updatedSliderModel, sliderCmd ) =
              Slider.update (Slider.MouseDown <| relativePos pos (SliderHandle sliderHandle))
                            (sliderHandle.getter model)
        in
          ( sliderHandle.setter
                { model | activeSlider = Just <| SliderHandle sliderHandle }
                updatedSliderModel
          , Cmd.none
          )
      Nothing ->
        ( model
        , Cmd.none
        )


handleMouseUp : IntVector2 -> Model -> (Model, Cmd Msg)
handleMouseUp pos model =
  case model.activeSlider of
    Just (SliderHandle sliderHandle) ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update (Slider.MouseUp <| relativePos pos (SliderHandle sliderHandle))
                          (sliderHandle.getter model)
      in
        ( sliderHandle.setter
              { model | activeSlider = Nothing }
              updatedSliderModel
        , Cmd.none
        )
    Nothing ->
      ( model
      , Cmd.none
      )


mouseOverWhichSlider : IntVector2 -> Model -> Maybe SliderHandle
mouseOverWhichSlider pos model =
  if pos.y < 1*sliderSep then
    Just <| SliderHandle
      { getter = (.decayTime)
      , setter = \m s -> { m | decayTime = s }
      , msg = DecayTime
      , relativePos = { x = 0, y = 0 }
      }
  else if pos.y < 2*sliderSep then
    Just <| SliderHandle
      { getter = (.rainIntensity)
      , setter = \m s -> { m | rainIntensity = s }
      , msg = RainIntensity
      , relativePos = { x = 0, y = 1*sliderSep }
      }
  else if pos.y < 3*sliderSep then
    Just <| SliderHandle
      { getter = (.backgroundNoiseLevel)
      , setter = \m s -> { m | backgroundNoiseLevel = s }
      , msg = BackgroundNoiseLevel
      , relativePos = { x = 0, y = 2*sliderSep }
      }
  else if pos.y < 4*sliderSep then
    Just <| SliderHandle
      { getter = (.dropLevel)
      , setter = \m s -> { m | dropLevel = s }
      , msg = DropLevel
      , relativePos = { x = 0, y = 3*sliderSep }
      }
  else if pos.y < 5*sliderSep then
    Just <| SliderHandle
      { getter = (.reverbLevel)
      , setter = \m s -> { m | reverbLevel = s }
      , msg = ReverbLevel
      , relativePos = { x = 0, y = 4*sliderSep }
      }
  else if pos.y < 6*sliderSep then
    Just <| SliderHandle
      { getter = (.masterVolume)
      , setter = \m s -> { m | masterVolume = s }
      , msg = MasterVolume
      , relativePos = { x = 0, y = 5*sliderSep }
      }
  else
    Nothing


-- VIEW

sliderSep : Int
sliderSep = 90

view : Model -> Html Msg
view model =
  div []
    [ div [ style <| sliderPositioning 0 (0*sliderSep) ]
        [ Html.App.map DecayTime              <| Slider.view model.decayTime ]
    , div [ style <| sliderPositioning 0 (1* sliderSep) ]
        [ Html.App.map RainIntensity          <| Slider.view model.rainIntensity ]
    , div [ style <| sliderPositioning 0 (2*sliderSep) ]
        [ Html.App.map BackgroundNoiseLevel   <| Slider.view model.backgroundNoiseLevel ]
    , div [ style <| sliderPositioning 0 (3*sliderSep) ]
        [ Html.App.map DropLevel              <| Slider.view model.dropLevel ]
    , div [ style <| sliderPositioning 0 (4*sliderSep) ]
        [ Html.App.map ReverbLevel            <| Slider.view model.reverbLevel ]
    , div [ style <| sliderPositioning 0 (5*sliderSep) ]
        [ Html.App.map MasterVolume           <| Slider.view model.masterVolume ]
    ]


sliderPositioning : Int -> Int -> List (String, String)
sliderPositioning x y =
  [ ("position", "absolute")
  , ("left", toString x)
  , ("top", toString y)
  ]
