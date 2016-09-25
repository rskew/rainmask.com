port module Cmds exposing (raindropPort
                          , setTimerPort
                          , backgroundNoisePort
                          , togglePort
                          , dryLevelPort
                          , reverbLevelPort
                          , masterVolumePort
                          )

import Model exposing (Vector3)

port raindropPort : (Float, Vector3) -> Cmd msg

port setTimerPort : (List Float) -> Cmd msg

port backgroundNoisePort : (List Float) -> Cmd msg

port togglePort : (List Bool) -> Cmd msg

port dryLevelPort : (List Float) -> Cmd msg

port reverbLevelPort : (List Float) -> Cmd msg

port masterVolumePort : (List Float) -> Cmd msg

-- init : Float -> (List Float) -> (List Float) -> 
