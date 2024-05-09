module Responsiveness.Types exposing (..)

import Browser.Dom exposing (Viewport)
import Element exposing (Device)


-- Model
type alias Model = Device


-- Msg
type Msg
    = DeviceClassified Device
    | GotInitialViewport Viewport
