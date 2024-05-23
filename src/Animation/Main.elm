module Animation.Main exposing (main)

import Task
import Browser
import Browser.Events exposing (onResize)
import Element exposing (classifyDevice)
import Browser.Dom exposing (getViewport)
import Animation.Types exposing (..)
import Animation.View exposing (..)



main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


-- INIT
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


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    onResize <|
        \width height ->
            DeviceClassified (classifyDevice { width = width, height = height })


-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DeviceClassified device ->
            ( device
            , Cmd.none
            )
        GotInitialViewport vp ->
            ( classifyDevice { width = round vp.viewport.width, height = round vp.viewport.height}
            , Cmd.none
            )
        -- TODO route page or do something when pressed
        UserPressedButton ->
            ( model
            , Cmd.none)