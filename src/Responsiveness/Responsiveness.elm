module Responsiveness.Responsiveness exposing (..)

import Browser
import Html exposing (Html)
import Browser.Events exposing (onResize)
import Browser.Dom exposing (Viewport)
import Task
import Element 
    exposing
        ( Attribute
        , Device
        , DeviceClass(..)
        , Element
        , Orientation(..)
        , column
        , el
        , fill
        , fillPortion
        , height
        , layout
        , padding
        , paragraph
        , row
        , text
        , width
        , spacing
        , inFront
        ,rgb255
        )
import Element.Background as Background
import Element.Region as Region


-- Model

type alias Window =
    { width : Int
    , height : Int
    }

type alias Model = Device

initialModel : Model
initialModel =
    let
        window_ = { width = 0, height = 0}
    in
    Element.classifyDevice window_


-- Msg
type Msg
    = DeviceClassified Device
    | GotInitialViewport Viewport
    | Nothing

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width_ height_ ->
            DeviceClassified (Element.classifyDevice { width = width_, height = height_ })

-- Update
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DeviceClassified device_ ->
            ( device_
            , Cmd.none
            )
        GotInitialViewport vp ->
            ( Element.classifyDevice { width = round vp.viewport.width, height = round vp.viewport.height}
              , Cmd.none
            )
        Nothing ->
            (model, Cmd.none)

-- View

view : Model -> Html Msg
view model =
    case ( model.class, model.orientation ) of
        ( Phone, _ ) ->
            phoneLayout

        ( Tablet, _ ) ->
            tabletLayout

        ( Desktop, Portrait ) ->
            tabletLayout

        ( Desktop, _ ) ->
            desktopLayout

        ( BigDesktop, _ ) ->
            bigDesktopLayout

phoneLayout : Html Msg
phoneLayout =
    layout [ height fill, width fill, inFront <| header []]
        <| column [ height fill, width fill ]
            [ el [ padding 15, width fill] (text "dummy")
            , menu []
            , content []
            , content []
            , content []
            , content []
            , related []
            , footer []
            ]


tabletLayout : Html Msg
tabletLayout =
    layout [ height fill, width fill ] 
        <| column [ height fill, width fill ]
            [ header []
            , content []
            , content []
            , content []
            , row [ width fill ]
                [ menu []
                , related []
                ]
            , footer []
            ]


desktopLayout : Html Msg
desktopLayout =
    layout [ height fill, width fill ] 
        <| column [ height fill, width fill ]
            [ header []
            , row [ height fill ]
                [ menu [ width (fillPortion 1), height fill ]
                , content [ width (fillPortion 3), height fill ]
                , related [ width (fillPortion 1), height fill ]
                ]
            , footer []
            ]


bigDesktopLayout : Html Msg
bigDesktopLayout =
    desktopLayout


header : List (Attribute Msg) -> Element Msg
header attr =
    el
        ([ Background.color <| rgb255 255 99 71 -- red
         , padding 15
         , width fill
         ]
            ++ attr
        )
        (Element.text "Header")


menu : List (Attribute Msg) -> Element Msg
menu attr =
    el
        ([ Background.color <| rgb255 0 255 128 -- green?
         , padding 15
         , width fill
         , Region.navigation
         ]
            ++ attr
        )
        (text "Menu")


content : List (Attribute Msg) -> Element Msg
content attr =
    el
        ([ Background.color <| rgb255 224 224 224 --light gray i hope
         , padding 15
         , width fill
         , height fill
         , Region.mainContent
         ]
            ++ attr
        )
    <|
        paragraph
            [ spacing 10]
            -- FLATLAND A Romance of Many Dimensions (1884) by Edwin Abbott Abbott
            [ el [] (text """I call our world Flatland, not because we call it so, but to make its nature clearer to you, my happy
                    readers, who are privileged to live in Space.
                    Imagine a vast sheet of paper on which straight Lines, Triangles, Squares, Pentagons, Hexagons, and
                    other figures, instead of remaining fixed in their places, move freely about, on or in the surface, but
                    without the power of rising above or sinking below it, very much like shadows - only hard and with
                    luminous edges - and you will then have a pretty correct notion of my country and countrymen. Alas, a
                    few years ago, I should have said ``my universe''; but now my mind has been opened to higher views of
                    things.
                    In such a country, you will perceive at once that it is impossible that there should be anything of what
                    you call a ``solid'' kind; but I dare say you will suppose that we could at least distinguish by sight the
                    Triangles, Squares, and other figures, moving about as I have described them. On the contrary, we could
                    see nothing of the kind, not at least so as to distinguish one figure from another. Nothing was visible, nor
                    could be visible, to us, except Straight Lines; and the necessity of this I will speedily demonstrate.
                    Place a penny on the middle of one of your tables in Space; and leaning over it, look down upon it. It will
                    appear a circle. """) 
            ]


related : List (Attribute Msg) -> Element Msg
related attr =
    el
        ([ Background.color <| rgb255 255 255 51 -- yellow
         , padding 15
         , width fill
         , Region.aside
         ]
            ++ attr
        )
        (text "Related content")


footer : List (Attribute Msg) -> Element Msg
footer attr =
    el
        ([ Background.color <| rgb255 255 99 71 --red
         , padding 15
         , width fill
         , Region.footer
         ]
            ++ attr
        )
        (text "Footer")

-- Main
main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err _ ->
                    Nothing

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> (initialModel, Task.attempt handleResult Browser.Dom.getViewport)
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
