module RainParams exposing (..)

import Utils exposing (Vector3)

import Random

randVector3Gen : Random.Generator Vector3
randVector3Gen =
  Random.map3 Vector3
                ( Random.float -20 20 )
                ( Random.float -20 20 )
                ( Random.float 5 10 )
