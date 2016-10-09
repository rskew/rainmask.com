module Schedule exposing ( drops
                         , interval
                         , lookahead
                         , inactiveLookahead
                         )

import Model exposing (Model)
import Utils exposing ( WATime
                      , JSTime
                      )


interval : JSTime
interval = 200

lookahead : WATime
lookahead = 0.4

inactiveLookahead : WATime
inactiveLookahead = 1.5

drops : WATime -> WATime -> Model -> (List WATime)
drops timerTick nextNoteTime model =
  let
    buffer = if model.visibility == True then
               lookahead
             else
               inactiveLookahead
  in
    if nextNoteTime > timerTick + buffer then
      []
    else if model.sliders.rainIntensity.value == 0 then
      []
    else if nextNoteTime <= timerTick then
      (drops timerTick (timerTick + 1/model.sliders.rainIntensity.value) model)
    else
      (drops timerTick
             (nextNoteTime + (1 / model.sliders.rainIntensity.value))
             --(nextNoteTime + 0.2)
             model)
      ++ [ nextNoteTime ]
      --[ timerTick + (1 / model.sliders.rainIntensity.value) ]
