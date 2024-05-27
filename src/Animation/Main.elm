module Animation.Main exposing (..)

import Task
import Animator
import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onResize)
import Dict
import Element exposing (..)
import Element.Events exposing (..)
import Animation.View exposing (..)
import Animation.Types exposing (..)


animator : Animator.Animator Model
animator =
    Animator.animator
        |> Animator.watchingWith
            .buttonStates
            (\newButtonStates model ->
                { model | buttonStates = newButtonStates }
            )
            (\buttonStates ->
                List.any ((==) Hover) <| Dict.values buttonStates
            )


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
    ( 
        { device = device
        , buttonStates = 
            Animator.init 
                <| Dict.fromList 
                    <| List.map (\key -> (key, Default)) buttonLabels
        }
        ,  Task.attempt handleResult getViewport
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Animator.toSubscription RuntimeTriggeredAnimationStep model animator
        , onResize <|
            \width_ height_ ->
                DeviceClassified (Element.classifyDevice { width = width_, height = height_ })
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        maybeAlways value =
            Maybe.map (\_ -> value)

        setButtonState id newState =
            Dict.update id (maybeAlways newState) <| Animator.current model.buttonStates
    in
    case msg of
        RuntimeTriggeredAnimationStep newTime -> 
            ( Animator.update newTime animator model
            , Cmd.none
            )

        UserHoveredButton id ->
            ( { model
                | buttonStates =
                    Animator.go Animator.slowly (setButtonState id Hover) model.buttonStates
              }
            , Cmd.none
            )

        UserUnhoveredButton id ->
            ( { model
                | buttonStates =
                    Animator.go Animator.slowly (setButtonState id Default) model.buttonStates
              }
            , Cmd.none
            )
        
        DeviceClassified device ->
            ( { model 
                | device = device
              }
            , Cmd.none
            )
        GotInitialViewport vp ->
            ( { model 
                | device = 
                    Element.classifyDevice 
                        { width = round vp.viewport.width
                        , height = round vp.viewport.height
                        }
              }
              , Cmd.none
            )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }