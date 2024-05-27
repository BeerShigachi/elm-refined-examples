module Animation.View exposing (..)

import Animator
import Color
import Dict
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (..)
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Animation.Types exposing (..)


-- View
view : Model -> Html Msg
view model =
    case ( model.device.class, model.device.orientation ) of
        ( Phone, _ ) ->
            phoneLayout model

        ( Tablet, _ ) ->
            tabletLayout model

        ( Desktop, Portrait ) ->
            tabletLayout model

        ( Desktop, _ ) ->
            desktopLayout model

        ( BigDesktop, _ ) ->
            bigDesktopLayout model


-- Layouts
phoneLayout : Model -> Html Msg
phoneLayout model =
    layout [ height fill, width fill, inFront <| header []]
        <| column [ height fill, width fill ]
            [ header []
            , menu []
            , content []
            , animatedContent [] model
            , animatedButtons model buttonLabels
            , animatedButton model firstLable
            , footer []
            ]


tabletLayout : Model -> Html Msg
tabletLayout model =
    layout [ height fill, width fill ] 
        <| column [ height fill, width fill ]
            [ header []
            , row [ width fill ]
                [ content []
                , animatedContent [] model
                ]
            , footer []
            ]


desktopLayout : Model -> Html Msg
desktopLayout model =
    layout [ height fill, width fill ] 
        <| column [ height fill, width fill ]
            [ header []
            , row [ height fill ]
                [ menu [ width (fillPortion 1), height fill ]
                , animatedContent [ width (fillPortion 1), height fill ] model
                , content [ width (fillPortion 3), height fill ]
                ]
            , footer []
            ]


bigDesktopLayout : Model -> Html Msg
bigDesktopLayout =
    desktopLayout


-- Elements
header : List (Attribute Msg) -> Element Msg
header attr =
    el
        ([ Background.color <| fromRgb <| Color.toRgba <| Color.blue
         , padding 15
         , width fill
         ]
            ++ attr
        )
        (Element.text "Header")


menu : List (Attribute Msg) -> Element Msg
menu attr =
    el
        ([ Background.color <| fromRgb <| Color.toRgba <| Color.blue
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
        ([ Background.color <| fromRgb <| Color.toRgba <| Color.lightGray
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


animatedContent : List (Attribute Msg) -> Model -> Element Msg
animatedContent attr model =
    el
        ([ Background.color <| fromRgb <| Color.toRgba <| Color.lightGray
         , padding 15
         , width fill
         , height fill
         , Region.mainContent
         ]
            ++ attr
        )
        <| animatedButtons model buttonLabels


footer : List (Attribute Msg) -> Element Msg
footer attr =
    el
        ([ Background.color <| fromRgb <| Color.toRgba <| Color.purple
         , padding 15
         , width fill
         , Region.footer
         ]
            ++ attr
        )
        (text "Footer")


firstLable : String
firstLable = "Un"

secondLable : String
secondLable = "Deux"

thirdLable : String
thirdLable = "Trois"

buttonLabels : List String
buttonLabels = [ firstLable, secondLable, thirdLable ]


animatedButton : Model -> String -> Element Msg
animatedButton model label =
    let
        buttonState =
            Maybe.withDefault Default <| Dict.get label <| Animator.current model.buttonStates

        borderColor =
            fromRgb <| Color.toRgba <|
                if buttonState == Hover then
                    Color.blue
                else
                    Color.black

        fontColor =
            fromRgb <| Color.toRgba <|
                if buttonState == Hover then
                    Color.white
                else
                    Color.black

        bgColor =
            fromRgb <| Color.toRgba <|
                Animator.color model.buttonStates <|
                    \buttonStates ->
                        if (Maybe.withDefault Default <| Dict.get label buttonStates) == Hover then
                            Color.lightBlue
                        else
                            Color.white

        fontSize =
            round <| Animator.linear model.buttonStates <|
                \buttonStates ->
                    Animator.at <|
                        if (Maybe.withDefault Default <| Dict.get label buttonStates) == Hover then
                            28
                        else
                            20

        buttonElement =
            el
                [ width <| px 200
                , height <| px 60
                , Border.width 3
                , Border.rounded 6
                , Border.color borderColor
                , Background.color bgColor
                , Font.color fontColor
                , Font.size fontSize
                , padding 10
                , onMouseEnter <| UserHoveredButton label
                , onMouseLeave <| UserUnhoveredButton label
                ]
            <| el [ centerX, centerY ] <| text <| "Button " ++ label
    in
    buttonElement

animatedButtons : Model -> List String -> Element Msg
animatedButtons model lables =
    List.map (animatedButton model) lables
        |> column [ spacing 10, centerX, centerY ]
