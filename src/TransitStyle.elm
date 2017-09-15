module TransitStyle
    exposing
        ( fadeSlide
        , fadeZoom
        , slide
        , slideOut
        , slideIn
        , fade
        , fadeOut
        , fadeIn
        , compose
        , zoom
        , zoomIn
        , zoomOut
        , Style
        )

{-| Animations for elm-transit, to be used on elm-html `style` attribute.

    div
      [ style (fadeSlide 100 model.transition) ]
      [ text "Some content" ]

    div
      [ style (fadeZoom 0.05 model.transition) ]
      [ text "Some content" ]

# Combinations
@docs fadeSlide, fadeZoom

# Slide left
@docs slide, slideOut, slideIn

# Fade
@docs fade, fadeOut, fadeIn

# Zoom
@docs zoom, zoomIn, zoomOut

# Tooling to create animations
@docs compose, Style
-}

import Transit exposing (..)
import Ease exposing (..)


{-| Just an alias for elm-html style value
-}
type alias Style =
    List ( String, String )


{-| Compose an animation with `exit` and `enter` phases.
-}
compose : (Float -> Style) -> (Float -> Style) -> Transition -> Style
compose exit enter transition =
    case ( getStep transition, getValue transition ) of
        ( Exit, v ) ->
            exit v

        ( Enter, v ) ->
            enter v

        _ ->
            []


{-| Combine fade and slideLeft with the specified offset
-}
fadeSlide : Float -> Transition -> Style
fadeSlide offset t =
    (slide offset t) ++ (fade t)


{-| Combine fade and zoom with specified offset
-}
fadeZoom : Float -> Transition -> Style
fadeZoom offset t =
    ( zoom offset t ) ++ ( fade t )


{-| Slide animation, with the specified offset.
Greater than 0 to right, lesser to left.
-}
slide : Float -> Transition -> Style
slide offset =
    compose (slideOut offset) (slideIn offset)


{-| Slide out (exit) by translating on X for desired offset
-}
slideOut : Float -> Float -> Style
slideOut offset v =
    (Ease.outCubic (1 - v))
        * offset
        |> translateX


{-| Slide in (enter) by translating on X for desired offset
-}
slideIn : Float -> Float -> Style
slideIn offset v =
    (Ease.inCubic (1 - v))
        * offset
        |> translateX


-- Zoom animations
{-| Zoom animation
-}
zoom : Float -> Transition -> Style
zoom offset =
    compose ( zoomOut offset ) ( zoomIn offset )


{-| Zoom in (enter)
-}
zoomIn : Float -> Float -> Style
zoomIn offset v =
    Ease.linear ( ( v * offset ) + ( 1 - offset ) )
        |> scaleXY


{-| Zoom out (exit)
-}
zoomOut : Float -> Float -> Style
zoomOut offset v =
    Ease.inCubic ( ( v * offset ) + ( 1 - offset ) )
        |> scaleXY


{-| Fade animation
-}
fade : Transition -> Style
fade =
    compose fadeOut fadeIn


{-| Fade out (exit).
-}
fadeOut : Float -> Style
fadeOut v =
    inCubic v
        |> opacity


{-| Fade in (enter).
-}
fadeIn : Float -> Style
fadeIn v =
    outCubic v
        |> opacity



-- CSS styles


{-| Opacity style
-}
opacity : Float -> Style
opacity v =
    [ ( "opacity", toString v ) ]


{-| translateX style
-}
translateX : Float -> Style
translateX v =
    [ ( "transform", "translateX(" ++ toString v ++ "px)" )
    ]


{-| Scale style
-}
scaleXY : Float -> Style
scaleXY v =
    let
        target =
            String.concat
                [ "scale("
                , toString v
                , ","
                , toString v
                , ")"
                ]
    in
        [ ( "transform", target ) ]
