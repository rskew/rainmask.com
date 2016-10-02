module Model exposing ( Model
                      , Sliders
                      --, init
                      )

import Cmds
import Slider

  
type alias Sliders =
  { decayTime : Slider.Model
  , rainIntensity : Slider.Model
  , backgroundNoiseLevel : Slider.Model
  , dropLevel : Slider.Model
  , reverbLevel : Slider.Model
  , masterVolume : Slider.Model
  }

type alias Model =
  { sliders : Sliders
  , on : Bool
  }

--init : ( Model, Cmd msg )
--init =
--  let
--    ( decayTimeSlider, decayTimeInitCmd ) =
--        Slider.initialise { name = "Decay Time"
--                          , value = 1.78
--                          , max = 4
--                          , min = 0.001
--                          , updateCommand = \n -> Cmd.none
--                          , quant = False
--                          }
--    ( rainIntensitySlider, rainIntensityInitCmd) =
--        Slider.initialise { name = "Rain Intensity"
--                          , value = 80
--                          , max = 200
--                          , min = 1
--                          , updateCommand = Cmds.setTimerPort
--                          , quant = True
--                          }
--    ( backgroundNoiseLevelSlider, backgroundNoiseLevelInitCmd ) =
--        Slider.initialise { name = "Background Noise Level"
--                          , value = 0.17
--                          , max = 1
--                          , min = 0
--                          , updateCommand = Cmds.backgroundNoiseLevelPort
--                          , quant = False
--                          }
--    ( dropLevelSlider, dropLevelInitCmd ) =
--        Slider.initialise { name = "Raindrop Level"
--                          , value = 1
--                          , max = 1
--                          , min = 0
--                          , updateCommand = Cmds.dropLevelPort
--                          , quant = False
--                          }
--    ( reverbLevelSlider, reverbLevelInitCmd ) =
--        Slider.initialise { name = "Reverb Level"
--                          , value = 0.4
--                          , max = 1
--                          , min = 0
--                          , updateCommand = Cmds.reverbLevelPort
--                          , quant = False
--                          }
--    ( masterVolumeSlider, masterVolumeInitCmd ) =
--        Slider.initialise { name = "Master Volume"
--                          , value = 1
--                          , max = 1
--                          , min = 0
--                          , updateCommand = Cmds.masterVolumePort
--                          , quant = False
--                          }
--  in
--    ( Model
--        { decayTime = decayTimeSlider
--        , rainIntensity = rainIntensitySlider
--        , backgroundNoiseLevel = backgroundNoiseLevelSlider
--        , dropLevel = dropLevelSlider
--        , reverbLevel = reverbLevelSlider
--        , masterVolume = masterVolumeSlider
--        }
--      True
--    , Cmd.batch <| List.map (Cmd.map Update.SliderChange) [ decayTimeInitCmd
--                            , rainIntensityInitCmd
--                            , backgroundNoiseLevelInitCmd
--                            , dropLevelInitCmd
--                            , reverbLevelInitCmd
--                            , masterVolumeInitCmd
--                            ]
--    )
