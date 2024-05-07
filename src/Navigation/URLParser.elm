-- URLParserはリンクをクリックしてURLを変更し画面遷移を行うコード
-- NavigationにParseを追加したコード
module URLParser exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser as Pars exposing (Parser, parse, (</>), map, oneOf, s, string, top)

-- MAIN

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged  -- URLが変更されたときの処理
    , onUrlRequest = LinkClicked  -- リンクがクリックされたときの処理
    }

-- URL Routing

-- ルーティングのためのルートを定義
type Route
  = Home
  | Profile
  | Reviews String

-- URLパーサーを作成
routeParser : Parser (Route -> a) a
routeParser =
  oneOf
  [ Pars.map Home top
  , Pars.map Profile (Pars.s "profile")
  , Pars.map Reviews (Pars.s "reviews" </> string)
  ]
-- Pars.mapはパスパーサーを変換する(/reviews/public-opinionなど) 
-- Pars.sは指定された文字列と一致する場合、パスのセグメントを解析する

-- URLのパースを実行
toRoute : String -> Route
toRoute string =
  case Url.fromString string of
    Nothing -> -- 該当するURLがない場合、Homeを返す
      Home
    Just url -> -- 該当するURLがある場合、そのルートを返す
      Maybe.withDefault Home (parse routeParser url)

-- MODEL

-- ページモデル
type Page
  = HomePage
  | ProfilePage
  | ReviewsPage String

type alias Model =
  { key : Nav.Key -- ナビゲーションキー
  , url : Url.Url -- 現在のURL
  , page : Page -- 現在のページ
  }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
  ( Model key url HomePage, Cmd.none )

-- UPDATE

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url

-- URL更新時にURLのパースを実行
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          -- 内部リンクをクリックした場合、URLを変更する
          case toRoute (Url.toString url) of
            Home -> 
              ( { model | page = HomePage }, Nav.pushUrl model.key (Url.toString url) )
            Profile ->
              ( { model | page = ProfilePage }, Nav.pushUrl model.key (Url.toString url) )
            Reviews name ->
              ( { model | page = ReviewsPage name }, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      -- URLが変更された場合、各ページに遷移する
      case toRoute (Url.toString url) of
        Home ->
          ( { model | url = url, page = HomePage }
          , Cmd.none
          )
        Profile ->
          ( { model | url = url, page = ProfilePage }
          , Cmd.none
          )
        Reviews name ->
          ( { model | url = url, page = ReviewsPage name }
          , Cmd.none
          )

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

-- VIEW

view : Model -> Browser.Document Msg
view model =
  { title = "URL Interceptor"
  , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , case model.page of
          HomePage -> ul [] -- 各ページのリンクを表示
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/reviews/the-century-of-the-self"
            , viewLink "/reviews/public-opinion"
            , viewLink "/reviews/shah-of-shahs"
            ]
          ProfilePage -> p [] [ text "profile page" ] -- 遷移後の画面に表示されるテキスト
          ReviewsPage name -> p [] [ text (name ++ "'s review page.") ]
      ]
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]
