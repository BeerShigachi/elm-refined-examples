module Responsiveness.Main exposing (..)
import Browser

import Browser.Events exposing (onResize)
import Task
import Element 
    exposing
        ( DeviceClass(..)
        , Orientation(..)
        )
import Responsiveness.Types exposing (..)
import Responsiveness.View exposing (..)
import Browser.Dom


init : () -> ( Model, Cmd Msg )
init _ =
    let
        device = Element.classifyDevice { width = 0, height = 0}
        
        handleResult v =
            case v of
                Err _ ->
                    DeviceClassified device

                Ok vp ->
                    GotInitialViewport vp
    in
    (device, Task.attempt handleResult Browser.Dom.getViewport)
    



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
