module Rain exposing (..)

import Utils exposing ( Vector3
                      , WebAudioTime
                      )

import Random


type alias RainDrop =
  { channel : Int
  , decayTime : WebAudioTime
  , startTime : WebAudioTime
  , nextDropTime : WebAudioTime
  , pan : Vector3
  }


rainDropGenerator : RainDrop -> WebAudioTime -> WebAudioTime -> Random.Generator RainDrop
rainDropGenerator oldDrop timeConst decayTime =
  Random.map2 (RainDrop oldDrop.channel decayTime oldDrop.nextDropTime)
              (nextPoissonArrival oldDrop.nextDropTime timeConst)
              randVector3Generator


nextPoissonArrival : WebAudioTime -> Float -> Random.Generator Float
nextPoissonArrival thisDropTime timeConst =
  Random.map (\t -> thisDropTime
                    + (-1.0 / timeConst)
                    * (logBase e (1 - t)))
             (Random.float 0 1)


queueNextDrop : RainDrop -> List RainDrop -> List RainDrop
queueNextDrop rainDrop rainDropQueue =
  case rainDropQueue of
    nextDrop :: rest ->
      if rainDrop.startTime < nextDrop.startTime then
        rainDrop :: nextDrop :: rest
      else
        nextDrop :: queueNextDrop rainDrop rest
    [] ->
      [ rainDrop ]


randVector3Generator : Random.Generator Vector3
randVector3Generator =
  Random.map3 Vector3
                ( Random.float -20 20 )
                ( Random.float -20 20 )
                ( Random.float 5 10 )
