module TransitStyle
  ( fadeSlideLeft
  , slideLeft, slideOutLeft, slideInLeft
  , fade, fadeOut, fadeIn
  , compose, Style
  ) where

{-| Animations for elm-transit, to be used on elm-html `style` attribute.

    div
      [ style (fadeSlideLeft 100 model) ]
      [ text "content" ]

# Compositions
@docs fadeSlideLeft

# Slide left
@docs slideLeft, slideOutLeft, slideInLeft

# Fade
@docs fade, fadeOut, fadeIn

# Tooling to create animations
@docs compose, Style
-}

import Transit exposing (..)


{-| Alias for elm-html style value -}
type alias Style = List (String, String)


{-| Compose fade and slideLeft with the specified offset -}
fadeSlideLeft : Float -> Transition -> Style
fadeSlideLeft offset m =
  (slideLeft offset m) ++ (fade m)


{-| Slide left animation, with the specified offset -}
slideLeft : Float -> Transition -> Style
slideLeft offset m =
  compose (slideOutLeft offset) (slideInLeft offset) m


{-| Slide out to left (exit) -}
slideOutLeft : Float -> Float -> Style
slideOutLeft offset v =
  [ ("transform", "translateX(" ++ toString (-v * offset) ++ "px)")
  ]


{-| Slide in to left -}
slideInLeft : Float -> Float -> Style
slideInLeft offset v =
  [ ("transform", "translateX(" ++ toString (offset - v * offset) ++ "px)")
  ]


{-| Fade out/in animation -}
fade : Transition -> Style
fade m =
  compose fadeOut fadeIn m


{-| Fade out -}
fadeOut : Float -> Style
fadeOut v =
  [ ("opacity", toString (1 - v)) ]


{-| Fade in -}
fadeIn : Float -> Style
fadeIn v =
  [ ("opacity", toString v) ]


{-| Compose an animation with `exit` and `enter` phases. -}
compose : (Float -> Style) -> (Float -> Style) -> Transition -> Style
compose exit enter transition =
  case (getStatus transition, getValue transition) of
    (Exit, v) ->
      exit v
    (Enter, v) ->
      enter v
    _ ->
      []
