module Model exposing ( Model
                      --, init
                      )

import Cmds
import Sliders
import Utils exposing ( WATime
                      )

import Window

  
type alias Model =
  { sliders : Sliders.Model
  , on : Bool
  , nextDropTime : WATime
  , visibility : Bool
  , windowSize : Window.Size
  }
