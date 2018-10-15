module Main exposing (Model, Msg(..), Page(..), init, main, pageBg, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Transit exposing (Step(..))
import TransitStyle


type alias Model =
    Transit.WithTransition { page : Page }


type Page
    = Page1
    | Page2


type Msg
    = Click Page
    | SetPage Page
    | TransitMsg (Transit.Msg Msg)


init : a -> ( Model, Cmd Msg )
init _ =
    ( { page = Page1, transition = Transit.empty }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click page ->
            Transit.start TransitMsg (SetPage page) ( 100, 200 ) model

        SetPage page ->
            ( { model | page = page }, Cmd.none )

        TransitMsg transitMsg ->
            Transit.tick TransitMsg transitMsg model


view : Model -> Html Msg
view model =
    div
        [ style "margin" "20px 100px", style "overflow-x" "hidden" ]
        [ nav []
            [ a [ onClick (Click Page1) ] [ text "To page 1" ]
            , a [ onClick (Click Page2) ] [ text "To page 2" ]
            ]
        , div
            (style "background" (pageBg model.page) :: TransitStyle.fadeSlide 200 model.transition)
            [ p [] [ text (pageToString model.page) ]
            , p [] [ text (stepToString (Transit.getStep model.transition)) ]
            , p [] [ text (String.fromFloat (Transit.getValue model.transition)) ]
            ]
        ]


pageBg : Page -> String
pageBg page =
    case page of
        Page1 ->
            "red"

        Page2 ->
            "green"


subscriptions : Model -> Sub Msg
subscriptions model =
    Transit.subscriptions TransitMsg model


main : Program {} Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- helper


stepToString : Step -> String
stepToString step =
    case step of
        Exit ->
            "Exit"

        Enter ->
            "Enter"

        Done ->
            "Done"


pageToString : Page -> String
pageToString page =
    case page of
        Page1 ->
            "Page1"

        Page2 ->
            "Page2"
