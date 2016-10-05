module Model exposing ( Model
                      --, init
                      )

import Cmds
import Sliders
import Utils exposing (WATime)

  
type alias Model =
  { sliders : Sliders.Model
  , on : Bool
  , nextDropTime : WATime
  , visibility : Bool
  }
