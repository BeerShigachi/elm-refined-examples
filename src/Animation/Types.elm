module Animation.Types exposing (..)

import Browser.Dom exposing (Viewport)
import Animator
import Dict exposing (Dict)
import Element exposing (..)
import Element.Events exposing (..)
import Time


type State
    = Default
    | Hover


type alias Id =
    String


type Msg
    = RuntimeTriggeredAnimationStep Time.Posix
    | UserHoveredButton Id
    | UserUnhoveredButton Id
    | DeviceClassified Device
    | GotInitialViewport Viewport


type alias Model =
    { device : Device
    , buttonStates : Animator.Timeline (Dict Id State) 
    }