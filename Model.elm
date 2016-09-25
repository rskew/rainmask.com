module Model exposing (Model, init, Vector3)


type alias Model =
  { decayTime : Float
  , rainIntensity : Int
  , backgroundNoiseLevel : Float
  , dryLevel : Float
  , reverbLevel : Float
  , masterVolume : Float
  , on : Bool
  }

init : (Model, Cmd msg)
init =
  ( Model 1.78 80 0.17 1 0.4 1 True
  , Cmd.none
  )

type alias Vector3 =
  { x : Float
  , y : Float
  , z : Float
  }

