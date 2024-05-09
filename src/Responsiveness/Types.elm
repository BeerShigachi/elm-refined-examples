module Responsiveness.Types exposing (..)
import Element exposing (Device)
import Browser.Dom exposing (Viewport)

-- Model
type alias Model = Device

-- Msg
type Msg
    = DeviceClassified Device
    | GotInitialViewport Viewport
