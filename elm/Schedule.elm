module Schedule exposing ( interval
                         , withinLookahead
                         )

import Model exposing (Model)
import Utils exposing ( WebAudioTime
                      , JSTime
                      )

import List


interval : JSTime
interval = 200

lookahead : WebAudioTime
lookahead = 0.4

inactiveLookahead : WebAudioTime
inactiveLookahead = 1.5


withinLookahead : WebAudioTime -> WebAudioTime -> Model -> Bool
withinLookahead timerTick nextDropTime model =
  let
    buffer = if model.visibility == True then
               lookahead
             else
               inactiveLookahead
  in
    if nextDropTime < timerTick + buffer then
      True
    else
      False
