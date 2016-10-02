module Update exposing ( Msg (..)
                       , SliderMsg (..)
                       , update
                       , init
                       )

import Model exposing ( Model
                      , Sliders
                      )
import Utils exposing ( Vector3
                      , Time
                      )
import Cmds exposing ( raindropPort
                     , setTimerPort
                     , backgroundNoiseLevelPort
                     , togglePort
                     , dropLevelPort
                     , reverbLevelPort
                     , masterVolumePort
                     )
import RainParams exposing (randVector3Gen)
import Slider

import String exposing (toFloat)
import Random
import Focus


type SliderMsg
  = DecayTime               Slider.Msg
  | RainIntensity           Slider.Msg
  | BackgroundNoiseLevel    Slider.Msg
  | DropLevel               Slider.Msg
  | ReverbLevel             Slider.Msg
  | MasterVolume            Slider.Msg

type Msg
  = Drop Time Vector3
  | GenerateDrop Time
  | SliderChange SliderMsg
  | ToggleOnOff

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Drop time pan ->
      ( model
      , if model.on then
          raindropPort ( time
                       , model.sliders.decayTime.value
                       , pan
                       )
        else
          Cmd.none
      )

    GenerateDrop time ->
      ( model
      , Random.generate (Drop time) randVector3Gen
      )

    ToggleOnOff ->
      if model.on == True then
        ( { model | on = False }
        , togglePort False
        )
      else
        ( { model | on = True }
        , togglePort True
        )

    SliderChange sliderMsg ->
      let
        ( updatedSliders, slidersCmd ) =
            sliderUpdate sliderMsg model.sliders
      in
        ( { model | sliders = updatedSliders }
        , Cmd.map SliderChange slidersCmd
        )


sliderUpdate : SliderMsg -> Sliders -> (Sliders, Cmd SliderMsg)
sliderUpdate sliderMsg sliders =
  case sliderMsg of
    DecayTime subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.decayTime
      in
        ( { sliders | decayTime = updatedSliderModel }
        , Cmd.map DecayTime sliderCmd
        )

    RainIntensity subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.rainIntensity
      in
        ( { sliders | rainIntensity = updatedSliderModel }
        , Cmd.map RainIntensity sliderCmd
        )

    BackgroundNoiseLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.backgroundNoiseLevel
      in
        ( { sliders | backgroundNoiseLevel = updatedSliderModel }
        , Cmd.map BackgroundNoiseLevel sliderCmd
        )

    DropLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.dropLevel
      in
        ( { sliders | dropLevel = updatedSliderModel }
        , Cmd.map DropLevel sliderCmd
        )

    ReverbLevel subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.reverbLevel
      in
        ( { sliders | reverbLevel = updatedSliderModel }
        , Cmd.map ReverbLevel sliderCmd
        )

    MasterVolume subMsg ->
      let
        ( updatedSliderModel, sliderCmd ) =
            Slider.update subMsg sliders.masterVolume
      in
        ( { sliders | masterVolume = updatedSliderModel }
        , Cmd.map MasterVolume sliderCmd
        )


init : ( Model, Cmd Msg )
init =
  let
    ( decayTimeSlider, decayTimeInitCmd ) =
        Slider.initialise { name = "Decay Time"
                          , value = 1.78
                          , max = 4
                          , min = 0.001
                          , updateCommand = \n -> Cmd.none
                          , quant = False
                          }
    ( rainIntensitySlider, rainIntensityInitCmd) =
        Slider.initialise { name = "Rain Intensity"
                          , value = 60
                          , max = 200
                          , min = 1
                          , updateCommand = Cmds.setTimerPort
                          , quant = True
                          }
    ( backgroundNoiseLevelSlider, backgroundNoiseLevelInitCmd ) =
        Slider.initialise { name = "Background Noise Level"
                          , value = 0.17
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.backgroundNoiseLevelPort
                          , quant = False
                          }
    ( dropLevelSlider, dropLevelInitCmd ) =
        Slider.initialise { name = "Raindrop Level"
                          , value = 1
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.dropLevelPort
                          , quant = False
                          }
    ( reverbLevelSlider, reverbLevelInitCmd ) =
        Slider.initialise { name = "Reverb Level"
                          , value = 0.4
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.reverbLevelPort
                          , quant = False
                          }
    ( masterVolumeSlider, masterVolumeInitCmd ) =
        Slider.initialise { name = "Master Volume"
                          , value = 1
                          , max = 1
                          , min = 0
                          , updateCommand = Cmds.masterVolumePort
                          , quant = False
                          }
  in
    ( Model
        { decayTime = decayTimeSlider
        , rainIntensity = rainIntensitySlider
        , backgroundNoiseLevel = backgroundNoiseLevelSlider
        , dropLevel = dropLevelSlider
        , reverbLevel = reverbLevelSlider
        , masterVolume = masterVolumeSlider
        }
      True
    , Cmd.batch <| List.map (Cmd.map SliderChange)
                      [ Cmd.map DecayTime decayTimeInitCmd
                      , Cmd.map RainIntensity rainIntensityInitCmd
                      , Cmd.map BackgroundNoiseLevel backgroundNoiseLevelInitCmd
                      , Cmd.map DropLevel dropLevelInitCmd
                      , Cmd.map ReverbLevel reverbLevelInitCmd
                      , Cmd.map MasterVolume masterVolumeInitCmd
                      ]
    )
