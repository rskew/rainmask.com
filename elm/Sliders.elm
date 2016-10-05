module Sliders exposing ( Model
                        , init
                        , Msg
                        , update
                        , view
                        )

import Slider
import Cmds

import Html exposing (Html, div)
import Html.App
                          
-- MODEL

type alias Model =
  { decayTime : Slider.Model
  , rainIntensity : Slider.Model
  , backgroundNoiseLevel : Slider.Model
  , dropLevel : Slider.Model
  , reverbLevel : Slider.Model
  , masterVolume : Slider.Model
  }


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
        decayTimeSlider
        rainIntensitySlider
        backgroundNoiseLevelSlider
        dropLevelSlider
        reverbLevelSlider
        masterVolumeSlider
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


update : Msg -> Model -> (Model, Cmd Msg)
update sliderMsg sliders =
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


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ Html.App.map DecayTime            <| Slider.view model.decayTime
    , Html.App.map RainIntensity        <| Slider.view model.rainIntensity
    , Html.App.map BackgroundNoiseLevel <| Slider.view model.backgroundNoiseLevel
    , Html.App.map DropLevel            <| Slider.view model.dropLevel
    , Html.App.map ReverbLevel          <| Slider.view model.reverbLevel
    , Html.App.map MasterVolume         <| Slider.view model.masterVolume
    ]
