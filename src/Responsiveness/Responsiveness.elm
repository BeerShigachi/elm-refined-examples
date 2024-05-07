module Responsiveness.Responsiveness exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Browser.Events exposing (onResize)
import Browser.Dom exposing (Viewport)
import Task
import Element exposing (Device)


-- Model

type alias Window =
    { width : Int
    , height : Int
    }

type alias Model =
    { device : Device
    , window : Window
    }

initialModel : Model
initialModel =
    let
        window_ = { width = 0, height = 0}
    in
    { device = Element.classifyDevice window_
    , window = window_ }


-- Msg

type Msg
    = DeviceClassified Device Window
    | GotInitialViewport Viewport
    | Nothing

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width_ height_ ->
            DeviceClassified (Element.classifyDevice { width = width_, height = height_ }) { width = width_, height = height_ }

-- Update
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DeviceClassified device_ window_ ->
            ( { model | device = device_, window = window_ }
            , Cmd.none
            )
        GotInitialViewport vp ->
            let
                window_ = { width = round vp.viewport.width, height = round vp.viewport.height}
            in
            ( { device = Element.classifyDevice window_ , window = window_}
              , Cmd.none
            )
        Nothing ->
            (model, Cmd.none)

-- View

view : Model -> Html Msg
view model =
    div
        [ style "background-color" "lightblue"
        , style "height" (String.fromInt model.window.height ++ "px")
        , style "width" (String.fromInt model.window.width ++ "px")
        , style "display" "flex"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ text "Responsive Design Example" ]

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
