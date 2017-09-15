# Elm Transit Style

    elm package install etaque/elm-transit-style

HTML animations for [elm-transit](http://package.elm-lang.org/packages/etaque/elm-transit/latest)'s `Transition`, to be used on elm-html `style` attribute. At the moment we have those, though it's easy to add more:

* `fade`
* `slide`
* `zoom`
* `fadeSlide`
* `fadeZoom`

An ideal companion to [elm-transit-router](http://package.elm-lang.org/packages/etaque/elm-transit-router/latest).

## How it works

A transition is composed of two phases: `Exit` then `Enter`. A style for a phase can be constructed with this signature:

```elm
Float -> Style
```

where the `Float` is the clock of transition phase, varying linear from 0 to 1. A `Style` is just an alias to `List (String, String)`.

A complete transition animation is constructed by composing exit and enter animations on a transition:

```elm
compose : (Float -> Style) -> (Float -> Style) -> Transition -> Style
```

It can then be used on a transition. Example for fade and left slide animation, with a 50px offset:

```elm
  div
    [ style (TransitStyle.fadeSlide 100 model.transition) ]
    [ text "Some content" ]
```

Example for fade and zoom animation with a 5% offset:
```elm
  div
    [ style (TransitStyle.fadeZoom 0.05 model.transition) ]
    [ text "Some content" ]
```

## Credits

* Easings are backed by [Easing](http://package.elm-lang.org/packages/Dandandan/Easing/latest) package.
