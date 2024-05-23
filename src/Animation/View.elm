module Animation.View exposing (..)


import Animation.Color exposing (..)
import Html exposing (Html)
import Element exposing (..)
import Animation.Types exposing (..)
import Element.Background as Background
import Element.Region as Region
import Element.Border as Border
import Element.Input as Input


--View
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


-- Layouts
phoneLayout : Html Msg
phoneLayout =
    layout [ height fill, width fill, inFront <| header []]
        <| column [ height fill, width fill ]
            [ header []
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
    layout [ height fill, width fill, inFront <| header [] ] 
        <| column [ height fill, width fill ]
            [ header []
            , menu []
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
    layout [ height fill, width fill, inFront <| header [] ] 
        <| column [ height fill, width fill ]
            [ header []
            , menu []
            , content []
            , footer []
            ]


bigDesktopLayout : Html Msg
bigDesktopLayout =
    desktopLayout


-- Elements

logo : Element msg
logo =
    el
        [ width <| px 80
        , height <| px 40
        , Border.width 2
        , Border.rounded 6
        , Border.color bgPrimary
        ]
        -- TODO replace none with logo img
        none 
        

headerButton : String -> Element Msg
headerButton label_ =
        Input.button
            [ focused [] -- this can removed global blue shadow around on clock
            , padding 10
            , Background.color primary

            -- The order of mouseDown/mouseOver can be significant when changing
            -- the same attribute in both
            , mouseDown
                [ Background.color secondary ]
            , mouseOver
                [ Background.color white ]
            ]
            { onPress = Just UserPressedButton, label = text label_ }


header : List (Attribute Msg) -> Element Msg
header attr =
    el
        ([ Background.color <| primary
         , width fill
         ]
            ++ attr
        )
        (row 
            [ width fill, padding 20, spacing 20]
            [ logo
            , el [ alignRight ] <| headerButton "Service"
            , el [ alignRight ] <| headerButton "About"
            , el [ alignRight ] <| headerButton "Contact"
            ]
        )


menu : List (Attribute Msg) -> Element Msg
menu attr =
    el
        ([ Background.color <| secondary
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
        ([ Background.color <| white
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
        ([ Background.color <| secondary
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
        ([ Background.color <| primary
         , padding 15
         , width fill
         , Region.footer
         ]
            ++ attr
        )
        (text "Footer")
