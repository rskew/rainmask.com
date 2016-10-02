port module Cmds exposing ( raindropPort
                          , setTimerPort
                          , backgroundNoiseLevelPort
                          , togglePort
                          , dropLevelPort
                          , reverbLevelPort
                          , masterVolumePort
                          )

import Utils exposing ( Vector3
                      , Time
                      )

port raindropPort : (Time, Float, Vector3) -> Cmd msg

port setTimerPort : Float -> Cmd msg

port backgroundNoiseLevelPort : Float -> Cmd msg

port dropLevelPort : Float -> Cmd msg

port reverbLevelPort : Float -> Cmd msg

port masterVolumePort : Float -> Cmd msg

port togglePort : Bool -> Cmd msg
