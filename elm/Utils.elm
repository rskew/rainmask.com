module Utils exposing ( Vector3
                      , IntVector2
                      , ContainerSize
                      , WebAudioTime
                      , JSTime
                      )

type alias WebAudioTime = Float

type alias JSTime = Float

type alias IntVector2 =
  { x : Int
  , y : Int
  }

type alias ContainerSize =
  { height : Int
  , width : Int
  }

type alias Vector3 =
  { x : Float
  , y : Float
  , z : Float
  }
