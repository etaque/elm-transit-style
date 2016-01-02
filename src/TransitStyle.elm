module TransitStyle
  ( fadeSlideLeft
  , slideLeft, slideOutLeft, slideInLeft
  , fade, fadeOut, fadeIn
  , compose, Style
  ) where

{-| Animations for elm-transit, to be used on elm-html `style` attribute.

    div
      [ style (fadeSlideLeft 100 model.transition) ]
      [ text "Some content" ]

# Combinations
@docs fadeSlideLeft

# Slide left
@docs slideLeft, slideOutLeft, slideInLeft

# Fade
@docs fade, fadeOut, fadeIn

# Tooling to create animations
@docs compose, Style
-}

import Transit exposing (..)
import Easing exposing (..)


{-| Just an alias for elm-html style value -}
type alias Style = List (String, String)


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


{-| Combine fade and slideLeft with the specified offset -}
fadeSlideLeft : Float -> Transition -> Style
fadeSlideLeft offset t =
  (slideLeft offset t) ++ (fade t)


{-| Slide left animation, with the specified offset -}
slideLeft : Float -> Transition -> Style
slideLeft offset =
  compose (slideOutLeft offset) (slideInLeft offset)


{-| Slide out to left -}
slideOutLeft : Float -> Float -> Style
slideOutLeft offset v =
  easeInCubic1 0 -offset v
    |> translateX


{-| Slide in to left -}
slideInLeft : Float -> Float -> Style
slideInLeft offset v =
  easeOutCubic1 offset 0 v
    |> translateX


{-| Fade animation -}
fade : Transition -> Style
fade =
  compose fadeOut fadeIn


{-| Fade out -}
fadeOut : Float -> Style
fadeOut v =
  easeInCubic1 1 0 v
    |> opacity


{-| Fade in -}
fadeIn : Float -> Style
fadeIn v =
  easeOutCubic1 0 1 v
    |> opacity


-- CSS styles

{-| Opacity style -}
opacity : Float -> Style
opacity v =
  [ ("opacity", toString v) ]

{-| translateX style -}
translateX : Float -> Style
translateX v =
  [ ("transform", "translateX(" ++ toString v ++ "px)")
  ]


-- easings (private)

easeOutCubic1 : Float -> Float -> Float -> Float
easeOutCubic1 from to =
  ease easeOutCubic float from to 1


easeInCubic1 : Float -> Float -> Float -> Float
easeInCubic1 from to =
  ease easeInCubic float from to 1

