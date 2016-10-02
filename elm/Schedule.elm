module Schedule exposing ( drops
                         , interval
                         , lookahead
                         )

import Model exposing (Model)
import Utils exposing ( WATime
                      , JSTime
                      )


interval : JSTime
interval = 1100

lookahead : WATime
lookahead = 1.5

drops : WATime -> WATime -> Model -> (List WATime)
drops timerTick nextNoteTime model =
  if nextNoteTime > timerTick + lookahead then
    []
  else
    [ nextNoteTime ] ++ 
        drops timerTick
               (nextNoteTime + (1 / model.sliders.rainIntensity.value))
               --(nextNoteTime + 0.1)
               model
