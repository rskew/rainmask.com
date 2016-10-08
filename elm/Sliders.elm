module Sliders exposing ( Model
                        , init
                        , Msg(..)
                        , update
                        , view
                        )

import Slider
import Cmds
import Utils exposing (IntVector2)

import Html exposing (Html, div)
import Html.App
import Html.Attributes exposing (style)
import Dict exposing (Dict)
import Mouse exposing ( position
                      , ups
                      , downs
                      )
import Window
                          
-- MODEL

type alias Model =
  { decayTime : Slider.Model
  , rainIntensity : Slider.Model
  , backgroundNoiseLevel : Slider.Model
  , dropLevel : Slider.Model
  , reverbLevel : Slider.Model
  , masterVolume : Slider.Model
  , activeSlider: ActiveSliderGetter
  }

type ActiveSliderGetter =
  ActiveSliderGetter (Model -> Maybe Slider.Model)


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
    ( { decayTime = decayTimeSlider
      , rainIntensity = rainIntensitySlider
      , backgroundNoiseLevel = backgroundNoiseLevelSlider
      , dropLevel = dropLevelSlider
      , reverbLevel = reverbLevelSlider
      , masterVolume = masterVolumeSlider
      , activeSlider = ActiveSliderGetter (\m -> Nothing)
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
  | ResizeWindow            Window.Size


update : Msg -> Model -> (Model, Cmd Msg)
update sliderMsg model =
  case sliderMsg of
    --DecayTime subMsg ->
    --  updateSlider (.decayTime)
    --               (\s m -> { model | decayTime = s })
    --               model
    --               subMsg

    --RainIntensity subMsg ->
    --  updateSlider (.rainIntensity)
    --               (\s m -> { model | rainIntensity = s })
    --               model
    --               subMsg

    --BackgroundNoiseLevel subMsg ->
    --  updateSlider (.backgroundNoiseLevel)
    --               (\s m -> { model | backgroundNoiseLevel = s })
    --               model
    --               subMsg

    --DropLevel subMsg ->
    --  updateSlider (.dropLevel)
    --               (\s m -> { model | dropLevel = s })
    --               model
    --               subMsg

    --ReverbLevel subMsg ->
    --  updateSlider (.reverbLevel)
    --               (\s m -> { model | reverbLevel = s })
    --               model
    --               subMsg

    --MasterVolume subMsg ->
    --  updateSlider (.masterVolume)
    --               (\s m -> { model | masterVolume = s })
    --               model
    --               subMsg


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
      --handleMouseMove pos
      ( model
      , Cmd.none
      )

    MouseDown pos ->
      --handleMouseDown pos
      ( model
      , Cmd.none
      )

    MouseUp pos ->
      --handleMouseDown pos
      ( model
      , Cmd.none
      )

    ResizeWindow size ->
      ( model
      , Cmd.none
      )



--updateSlider : (Model -> Slider.Model) -> (Slider.Model -> Model -> Model)
--                    -> Model -> Slider.Msg -> (Model, Cmd Msg)
--updateSlider getter setter model subMsg =
--  let
--    ( updatedSliderModel, sliderCmd ) =
--        Slider.update subMsg <| getter model
--  in
--    ( setter updatedSliderModel model
--    , Cmd.map DecayTime sliderCmd
--    )

--  case (Dict.get key model) of
--    Just sliderModel ->
--      let
--        ( updatedSliderModel, sliderCmd ) =
--            Slider.update subMsg sliderModel
--      in
--        ( Dict.update key (updateSlidersDict updatedSliderModel) model
--        , Cmd.map MasterVolume sliderCmd
--        )
--    Nothing ->
--      -- this should really exit screaming
--      ( model
--      , Cmd.none
--      )
  

--updateSlidersDict : Slider.Model -> Maybe Slider.Model -> Maybe Slider.Model
--updateSlidersDict newSlider thing =
--  case thing of
--    Nothing -> Nothing
--    Just slider -> Just newSlider


-- VIEW

view : Model -> Html Msg
view model =
  let
    separation = 70
  in
    div []
      [ div [ style <| sliderPositioning 0 (0*separation) ]
          --[ Html.App.map DecayTime            <| Slider.view (Dict.get "decay" model) ]
          [ Html.App.map DecayTime              <| Slider.view model.decayTime ]
          --(viewSlider DecayTime "decay" model)
      , div [ style <| sliderPositioning 0 (1* separation) ]
          --[ Html.App.map RainIntensity        <| Slider.view (Dict.get "intensity" model) ]
          [ Html.App.map RainIntensity          <| Slider.view model.rainIntensity ]
          --(viewSlider RainIntensity "intensity" model)
      , div [ style <| sliderPositioning 0 (2*separation) ]
          --[ Html.App.map BackgroundNoiseLevel <| Slider.view (Dict.get "backgroundNoise" model) ]
          [ Html.App.map BackgroundNoiseLevel   <| Slider.view model.backgroundNoiseLevel ]
          --(viewSlider BackgroundNoiseLevel "backgroundNoise" model)
      , div [ style <| sliderPositioning 0 (3*separation) ]
          --[ Html.App.map DropLevel            <| Slider.view (Dict.get "dropLevel" model) ]
          [ Html.App.map DropLevel              <| Slider.view model.dropLevel ]
          --(viewSlider DropLevel "dropLevel" model)
      , div [ style <| sliderPositioning 0 (4*separation) ]
          --[ Html.App.map ReverbLevel          <| Slider.view (Dict.get "reverbLevel" model) ]
          [ Html.App.map ReverbLevel            <| Slider.view model.reverbLevel ]
          --(viewSlider ReverbLevel "reverbLevel" model)
      , div [ style <| sliderPositioning 0 (5*separation) ]
          --[ Html.App.map MasterVolume         <| Slider.view (Dict.get "masterVolume" model) ]
          [ Html.App.map MasterVolume           <| Slider.view model.masterVolume ]
          --(viewSlider MasterVolume "masterVolume" model)
      ]


--viewSlider : (Slider.Msg -> Msg) -> String -> Model -> List (Html Msg)
--viewSlider msg key model =
--  case (Dict.get key model) of
--    Just sliderModel ->
--      [ Html.App.map msg <| Slider.view sliderModel ]
--    Nothing ->
--      []


sliderPositioning : Int -> Int -> List (String, String)
sliderPositioning x y =
  [ ("position", "absolute")
  , ("left", toString x)
  , ("top", toString y)
  ]
