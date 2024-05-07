-- NavigationはリンクをクリックすることでURLを変更するコード

module Navigation exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged  -- URLが変更された時、新しいUrlがonUrlChangeに送られる
    , onUrlRequest = LinkClicked  -- リンクがクリックされた時、UrlRequestとしてリンクを受け取る
    }

-- MODEL

type alias Model =
  { key : Nav.Key  -- ブラウザのナビゲーションキー
  , url : Url.Url  -- 現在のURL
  }

-- ナビゲーションバーから現在のUrlを取得
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url, Cmd.none )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest  -- ブラウザのURLリクエスト時のメッセージ
  | UrlChanged Url.Url  -- ブラウザのURLが変更されたときのメッセージ

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          -- 内部リンクをクリックした場合、現在のキーを使用してURLを変更
          ( model, Nav.pushUrl model.key (Url.toString url) )
          -- Nav.pushUrlはURLを変更し動作の制御を行う

        Browser.External href ->
          -- 外部リンクをクリックした場合、指定されたURLを読み込む
          ( model, Nav.load href ) -- Nav.loadは新しいHTMLを読み込む

    UrlChanged url ->
      -- ブラウザのURLが変更された場合、新しいURLで何を表示するのかを決める
      ( { model | url = url }, Cmd.none )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"  -- ページのタイトル
  , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]  -- 現在のページ名を表示
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          , viewLink "/reviews/the-century-of-the-self"
          , viewLink "/reviews/public-opinion"
          , viewLink "/reviews/shah-of-shahs"
          ]
      ]
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]
