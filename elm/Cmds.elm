port module Cmds exposing ( rainDropPort
                          , setTimerPort
                          , backgroundNoiseLevelPort
                          , togglePort
                          , dropLevelPort
                          , reverbLevelPort
                          , masterVolumePort
                          )

import Utils exposing ( Vector3
                      , WebAudioTime
                      , JSTime
                      )
import Rain exposing (RainDrop)

port rainDropPort : RainDrop -> Cmd msg

port setTimerPort : Float -> Cmd msg

port backgroundNoiseLevelPort : Float -> Cmd msg

port dropLevelPort : Float -> Cmd msg

port reverbLevelPort : Float -> Cmd msg

port masterVolumePort : Float -> Cmd msg

port togglePort : Bool -> Cmd msg
