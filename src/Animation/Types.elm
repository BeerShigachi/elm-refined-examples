module Animation.Types exposing (..)

import Element exposing (Device)
import Browser.Dom exposing (Viewport)


type Https = Https String -- TODO replace with URL lib. https://package.elm-lang.org/packages/elm/url/latest/


type Path = Path String -- TODO replace with Path module. check examples/URLParser.elm


type alias Model = Device


type Msg
    = DeviceClassified Device
    | GotInitialViewport Viewport
    | UserPressedButton -- TODO route page or do something
