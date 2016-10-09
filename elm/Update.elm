module Update exposing ( Msg (..)
                       , update
                       , sliderMargin
                       , init
                       )

import Model exposing ( Model
                      )
import Utils exposing ( Vector3
                      , IntVector2
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
import Sliders
import Schedule

import String exposing (toFloat)
import Random
import Update.Extra exposing (sequence)
import List
import Mouse exposing ( position
                      , ups
                      , downs
                      )
import Window


type Msg
  = Drop WATime Vector3
  | GenerateDrop WATime
  | ScheduleDrops WATime
  | SliderChange Sliders.Msg
  | ToggleOnOff
  | VisibilityChange Bool
  | MouseMove IntVector2
  | MouseUp IntVector2
  | MouseDown IntVector2
  | ResizeWindow Window.Size

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
      in
        case List.head drops of
          Just (GenerateDrop startTime) ->
            sequence update drops ( { model | nextDropTime = startTime }
                                  , Cmd.none
                                  )
          _ ->
            ( model
            , Cmd.none
            )

    SliderChange slidersMsg ->
      let
        ( updatedSliders, slidersCmd ) =
            Sliders.update slidersMsg model.sliders
      in
        ( { model | sliders = updatedSliders }
        , Cmd.map SliderChange slidersCmd
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

    VisibilityChange state ->
      ( { model | visibility = state }
      , Cmd.none
      )

    MouseMove pos ->
      let
        ( updatedSliders, slidersCmd ) =
            Sliders.update (Sliders.MouseMove <| relativePos pos model) model.sliders
      in
        ( { model | sliders = updatedSliders }
        , Cmd.map SliderChange slidersCmd
        )

    MouseDown pos ->
      let
        ( updatedSliders, slidersCmd ) =
            Sliders.update (Sliders.MouseDown <| relativePos pos model) model.sliders
      in
        ( { model | sliders = updatedSliders }
        , Cmd.map SliderChange slidersCmd
        )

    MouseUp pos ->
      let
        ( updatedSliders, slidersCmd ) =
            Sliders.update (Sliders.MouseUp <| relativePos pos model) model.sliders
      in
        ( { model | sliders = updatedSliders }
        , Cmd.map SliderChange slidersCmd
        )

    ResizeWindow newSize ->
      ( { model | windowSize = newSize }
      , Cmd.none
      )


relativePos : IntVector2 -> Model -> IntVector2
relativePos pos model =
  { x = pos.x - sliderMargin.x, y = pos.y - sliderMargin.y }


sliderMargin : IntVector2
sliderMargin = { x = 30, y = 40 }


init : ( Model, Cmd Msg )
init =
  let
    ( initSliders, initSlidersCmd ) =
        Sliders.init { height = 800, width = 400 }
  in
    ( Model
        initSliders
        True
        0
        True
        { height = 800, width = 400 }
    , Cmd.batch [ Cmd.map SliderChange initSlidersCmd
                -- initialise timer
                , setTimerPort Schedule.interval
                ]
    )
