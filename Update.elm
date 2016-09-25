module Update exposing (Msg (..), update)

import Model exposing (Model, Vector3)
import Cmds exposing (raindropPort
                     , setTimerPort
                     , backgroundNoisePort
                     , togglePort
                     , dryLevelPort
                     , reverbLevelPort
                     , masterVolumePort
                     )
import RainParams exposing (randVector3Gen)

import String exposing (toFloat)
import Random


type Msg
  = Drop Vector3
  | GenerateDrop String
  | UpdateDecay String
  | UpdateIntensity String
  | BackgroundNoiseLevel String
  | DryLevel String
  | ReverbLevel String
  | MasterVolume String
  | ToggleOnOff

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Drop pan ->
      ( model
      , if model.on then
          raindropPort ( model.decayTime
                       , pan
                       )
        else
          Cmd.none
      )

    GenerateDrop str ->
      ( model
      , Random.generate Drop <| randVector3Gen
      )

    UpdateDecay str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            ( if num == 0 then
                model
              else
                { model | decayTime = num / 1000 }
            , Cmd.none
            )
          Err msg ->
            ( model
            , Cmd.none
            )

    UpdateIntensity str ->
      let
        try = String.toInt str
      in
        case try of
          Ok num ->
            if num == 0 then
              ( model
              , Cmd.none
              )
            else
              ( { model | rainIntensity = num }
              , setTimerPort [ 1000 / Basics.toFloat num ]
              )
          Err msg ->
            ( model
            , Cmd.none
            )

    BackgroundNoiseLevel str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            ( { model | backgroundNoiseLevel = num / 100 }
            , backgroundNoisePort [ num / 100 ]
            )
          Err msg ->
            ( model
            , Cmd.none
            )

    DryLevel str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            ( { model | dryLevel = num / 100 }
            , dryLevelPort [ num / 100 ]
            )
          Err msg ->
            ( model
            , Cmd.none
            )

    ReverbLevel str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            ( { model | reverbLevel = num / 100 }
            , reverbLevelPort [ num / 100 ]
            )
          Err msg ->
            ( model
            , Cmd.none
            )

    MasterVolume str ->
      let
        try = String.toFloat str
      in
        case try of
          Ok num ->
            ( { model | masterVolume = num / 100 }
            , masterVolumePort [ num / 100 ]
            )
          Err msg ->
            ( model
            , Cmd.none
            )

    ToggleOnOff ->
      if model.on == True then
        ( { model | on = False }
        , togglePort []
        )
      else
        ( { model | on = True }
        , togglePort []
        )
