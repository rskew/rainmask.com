module Utils exposing ( Vector3
                      , IntVector2
                      , WATime
                      , JSTime
                      , unfoldr
                      )

type alias WATime = Float

type alias JSTime = Float

type alias IntVector2 =
  { x : Int
  , y : Int
  }

type alias Vector3 =
  { x : Float
  , y : Float
  , z : Float
  }


unfoldr : (b -> Maybe (a,b)) -> b -> List a
unfoldr f b =
    let unfoldr' z f b = case f b of
        Nothing     -> z
        Just (a,b') -> unfoldr' (a::z) f b'
    in List.reverse <| unfoldr' [] f b
