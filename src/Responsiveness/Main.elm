module Responsiveness.Main exposing (..)

import Task
import Browser
import Browser.Events exposing (onResize)
import Browser.Dom exposing (getViewport)
import Element exposing (classifyDevice)
import Responsiveness.Types exposing (..)
import Responsiveness.View exposing (..)


init : () -> ( Model, Cmd Msg )
init _ =
    let
        device = classifyDevice { width = 0, height = 0}
        
        handleResult v =
            case v of
                Err _ ->
                    DeviceClassified device

                Ok vp ->
                    GotInitialViewport vp
    in
    (device, Task.attempt handleResult getViewport)
    

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width_ height_ ->
            DeviceClassified (Element.classifyDevice { width = width_, height = height_ })


-- Update
update : Msg -> Model -> ( Model, Cmd msg )
update msg _ =
    case msg of
        DeviceClassified device ->
            ( device
            , Cmd.none
            )
        GotInitialViewport vp ->
            ( Element.classifyDevice { width = round vp.viewport.width, height = round vp.viewport.height}
              , Cmd.none
            )


-- Main
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
