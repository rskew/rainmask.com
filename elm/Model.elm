module Model exposing ( Model
                      --, init
                      )

import Cmds
import Sliders
import Utils exposing ( WebAudioTime
                      )
import Rain exposing ( RainDrop
                     )

import Window

  
type alias Model =
  { sliders : Sliders.Model
  , on : Bool
  , rainDropQueue : List RainDrop
  , timeConst : WebAudioTime
  , visibility : Bool
  , windowSize : Window.Size
  }
