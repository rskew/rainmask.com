module Update exposing ( Msg (..)
                       , update
                       , sliderMargin
                       , init
                       )

import Model exposing ( Model
                      )
import Utils exposing ( Vector3
                      , IntVector2
                      , WebAudioTime
                      , JSTime
                      )
import Cmds exposing ( rainDropPort
                     , setTimerPort
                     , backgroundNoiseLevelPort
                     , togglePort
                     , dropLevelPort
                     , reverbLevelPort
                     , masterVolumePort
                     )
import Rain exposing ( RainDrop
                     , rainDropGenerator
                     , queueNextDrop
                     )
import Sliders
import Schedule exposing ( withinLookahead
                         )

import String exposing (toFloat)
import Random
import Update.Extra exposing (andThen, addCmd, sequence)
import Update.Extra.Infix exposing ((:>))
import List
import Mouse exposing ( position
                      , ups
                      , downs
                      )
import Window


type Msg
  = FireDrop RainDrop
  | QueueDrop WebAudioTime RainDrop
  | ScheduleDrops WebAudioTime
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
    FireDrop rainDrop ->
      ( model
      , if model.on then
          rainDropPort rainDrop
        else
          Cmd.none
      )

    QueueDrop timerTick rainDrop ->
      ( { model | rainDropQueue = queueNextDrop rainDrop model.rainDropQueue }
      , Cmd.none
      )
        :> update (ScheduleDrops timerTick)

    ScheduleDrops timerTick ->
      case model.rainDropQueue of
        nextDrop :: rest ->
          if withinLookahead timerTick nextDrop.startTime model then
            ( { model | rainDropQueue = rest }
            --, rainDropGenerator nextDrop model.timeConst
            , rainDropGenerator nextDrop model.sliders.rainIntensity.value
                model.sliders.decayTime.value
                |> Random.generate (QueueDrop timerTick)
            )
              :> update (FireDrop nextDrop)
          else
            ( model
            , Cmd.none
            )
              
        [] ->
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
        [ { channel = 0
          , decayTime = 1
          , startTime = 1
          , nextDropTime = 1.1
          , pan = (Vector3 -5 0 0)
          }
        , { channel = 1
          , decayTime = 1
          , startTime = 2
          , nextDropTime = 2.1
          , pan = (Vector3 2 0 0)
          }
        , { channel = 2
          , decayTime = 1
          , startTime = 3
          , nextDropTime = 3.1
          , pan = (Vector3 2 0 0)
          }
        , { channel = 3
          , decayTime = 1
          , startTime = 4
          , nextDropTime = 4.1
          , pan = (Vector3 5 0 0)
          }
        ]
        20
        True
        { height = 800, width = 400 }
    , Cmd.batch [ Cmd.map SliderChange initSlidersCmd
                -- initialise timer
                , setTimerPort Schedule.interval
                ]
    )
