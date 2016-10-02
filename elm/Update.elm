module Update exposing ( Msg (..)
                       , SliderMsg (..)
                       , update
                       , init
                       )

import Model exposing ( Model
                      , Sliders
                      )
import Utils exposing ( Vector3
                      , WATime
                      , JSTime
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
import Schedule

import String exposing (toFloat)
import Random
import Update.Extra exposing (sequence)
import List


type SliderMsg
  = DecayTime               Slider.Msg
  | RainIntensity           Slider.Msg
  | BackgroundNoiseLevel    Slider.Msg
  | DropLevel               Slider.Msg
  | ReverbLevel             Slider.Msg
  | MasterVolume            Slider.Msg

type Msg
  = Drop WATime Vector3
  | GenerateDrop WATime
  | ScheduleDrops WATime
  | SliderChange SliderMsg
  | ToggleOnOff

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Drop startTime pan ->
      ( model
      , if model.on then
          raindropPort ( startTime
                       , model.sliders.decayTime.value
                       , pan
                       --, { x = 0, y = 0, z = 3}
                       )
        else
          Cmd.none
      )

    GenerateDrop tickTime ->
      ( model
      , Random.generate (Drop tickTime) randVector3Gen
      )

    ScheduleDrops timerTick ->
      let
        drops = List.map GenerateDrop <|
                    Schedule.drops timerTick model.nextDropTime model
        nextDrop = case List.head drops of
                     Just (GenerateDrop startTime) ->
                       startTime
                     _ ->
                       timerTick
      in
        sequence update drops ( { model | nextDropTime = nextDrop }
                              , Cmd.none
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
                          --, updateCommand = Cmds.setTimerPort
                          , updateCommand = \n -> Cmd.none
                          , quant = True
                          }
    ( backgroundNoiseLevelSlider, backgroundNoiseLevelInitCmd ) =
        Slider.initialise { name = "Background Noise Level"
                          --, value = 0.17
                          , value = 0
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
        0
    , Cmd.batch <| List.map (Cmd.map SliderChange)
                      [ Cmd.map DecayTime decayTimeInitCmd
                      , Cmd.map RainIntensity rainIntensityInitCmd
                      , Cmd.map BackgroundNoiseLevel backgroundNoiseLevelInitCmd
                      , Cmd.map DropLevel dropLevelInitCmd
                      , Cmd.map ReverbLevel reverbLevelInitCmd
                      , Cmd.map MasterVolume masterVolumeInitCmd
                      -- initialise timer
                      , setTimerPort Schedule.interval
                      ]
    )
