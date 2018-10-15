# Elm Transit Style

    elm install etaque/elm-transit-style

HTML animations for [elm-transit](https://package.elm-lang.org/packages/etaque/elm-transit/latest)'s `Transition`, to be used on elm-html [`Attribute`](https://package.elm-lang.org/packages/elm/html/latest/Html#Attribute). At the moment we have those, though it's easy to add more:

- `fade`
- `slide`
- `zoom`
- `fadeSlide`
- `fadeZoom`

## How it works

A transition is composed of two phases: `Exit` then `Enter`. A style for a phase can be constructed with this signature:

```elm
Float -> List (Attribute msg)
```

where the `Float` is the clock of transition phase, varying linear from 0 to 1.

A complete transition animation is constructed by composing exit and enter animations on a transition:

```elm
compose : (Float -> List (Attribute msg)) -> (Float -> List (Attribute msg)) -> Transition -> List (Attribute msg)
```

It can then be used on a transition. Example for fade and left slide animation, with a 50px offset:

```elm
  div
    ( TransitStyle.fadeSlide 100 model.transition )
    [ text "Some content" ]
```

Example for fade and zoom animation with a 5% offset:

```elm
  div
    ( TransitStyle.fadeZoom 0.05 model.transition )
    [ text "Some content" ]
```

## Credits

- Easings are backed by [Easing](https://package.elm-lang.org/packages/elm-community/easing-functions/latest) package.
