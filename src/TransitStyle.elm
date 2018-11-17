module TransitStyle exposing
    ( fadeSlide, fadeZoom
    , slide, slideOut, slideIn
    , fade, fadeOut, fadeIn
    , zoom, zoomIn, zoomOut
    , compose
    )

{-| Animations for elm-transit, to be used on elm-html attributes.

    div
        (fadeSlide 100 model.transition)
        [ text "Some content" ]

    div
        (onClick (Click Page1) :: fadeZoom 0.05 model.transition)
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

@docs compose

-}

import Ease exposing (..)
import Html exposing (Attribute)
import Html.Attributes as Attributes
import String exposing (fromFloat)
import Transit exposing (..)


{-| Compose an animation with `exit` and `enter` phases.
-}
compose : (Float -> List (Attribute msg)) -> (Float -> List (Attribute msg)) -> Transition -> List (Attribute msg)
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
fadeSlide : Float -> Transition -> List (Attribute msg)
fadeSlide offset t =
    slide offset t ++ fade t


{-| Combine fade and zoom with specified offset
-}
fadeZoom : Float -> Transition -> List (Attribute msg)
fadeZoom offset t =
    zoom offset t ++ fade t


{-| Slide animation, with the specified offset.
Greater than 0 to right, lesser to left.
-}
slide : Float -> Transition -> List (Attribute msg)
slide offset =
    compose (slideOut offset) (slideIn offset)


{-| Slide out (exit) by translating on X for desired offset
-}
slideOut : Float -> Float -> List (Attribute msg)
slideOut offset v =
    Ease.outCubic (1 - v)
        * offset
        |> translateX


{-| Slide in (enter) by translating on X for desired offset
-}
slideIn : Float -> Float -> List (Attribute msg)
slideIn offset v =
    Ease.inCubic (1 - v)
        * offset
        |> translateX



-- Zoom animations


{-| Zoom animation
-}
zoom : Float -> Transition -> List (Attribute msg)
zoom offset =
    compose (zoomOut offset) (zoomIn offset)


{-| Zoom in (enter)
-}
zoomIn : Float -> Float -> List (Attribute msg)
zoomIn offset v =
    Ease.linear ((v * offset) + (1 - offset))
        |> scaleXY


{-| Zoom out (exit)
-}
zoomOut : Float -> Float -> List (Attribute msg)
zoomOut offset v =
    Ease.inCubic ((v * offset) + (1 - offset))
        |> scaleXY


{-| Fade animation
-}
fade : Transition -> List (Attribute msg)
fade =
    compose fadeOut fadeIn


{-| Fade out (exit).
-}
fadeOut : Float -> List (Attribute msg)
fadeOut v =
    inCubic v
        |> opacity


{-| Fade in (enter).
-}
fadeIn : Float -> List (Attribute msg)
fadeIn v =
    outCubic v
        |> opacity



-- CSS styles


{-| Opacity style
-}
opacity : Float -> List (Attribute msg)
opacity v =
    [ Attributes.style "opacity" (fromFloat v) ]


{-| translateX style
-}
translateX : Float -> List (Attribute msg)
translateX v =
    [ Attributes.style "transform" ("translateX(" ++ fromFloat v ++ "px)") ]


{-| Scale style
-}
scaleXY : Float -> List (Attribute msg)
scaleXY v =
    let
        target =
            String.concat
                [ "scale("
                , fromFloat v
                , ","
                , fromFloat v
                , ")"
                ]
    in
    [ Attributes.style "transform" target ]
