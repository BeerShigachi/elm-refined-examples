module Main exposing (..)

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
    }

initialModel : Model
initialModel =
    { device = Element.classifyDevice { width = 0, height = 0} }


-- Msg

type Msg
    = DeviceClassified Device
    | GotInitialViewport Viewport
    | Nothing

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width height ->
            DeviceClassified (Element.classifyDevice { width = width, height = height })

-- Update
update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DeviceClassified device_ ->
            ( { model | device = device_ }
            , Cmd.none
            )
        GotInitialViewport vp ->
            ( { device = Element.classifyDevice { width = round vp.viewport.width, height = round vp.viewport.height} }
              , Cmd.none
            )
        Nothing ->
            (model, Cmd.none)

-- View

view : Model -> Html Msg
view model =
    div
        [ style "background-color" "lightblue"
        , style "height" (String.fromInt model.device.height ++ "px")
        , style "width" (String.fromInt model.device.width ++ "px")
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
