# Elm Transit Style

    elm package install etaque/elm-transit-style

Animations for elm-transit, to be used on elm-html `style` attribute. At the moment we have those, though it's easy to add more:

* `fade`
* `slideLeft`
* `fadeSlideLeft`


## How it works

A transition is composed of two phases: `Exit` then `Enter`. A style for a phase can be constructed with this signature:

    Float -> Style
    
Where the `Float` is the clock of transition phase, varying from 0 to 1. A `Style` is just an alias to `List (String, String)`. 

A complete transition animation is constructed by composing exit and enter animations on a transition:

    compose : (Float -> Style) -> (Float -> Style) -> Transition -> Style

It can then be used on a transition. Example for fade and left slide animation, with a 50px offset:

```elm
  div
    [ style (TransitStyle.fadeSlideLeft 100 model.transition) ]
    [ text "Some content" ]
```

## Credits

* Easings are backed by [Easing](http://package.elm-lang.org/packages/Dandandan/Easing/latest) package.
