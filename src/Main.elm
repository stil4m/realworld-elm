module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Navigation



main =
  Navigation.program UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { history : List Navigation.Location
  , articles : List Article
  }

type alias Article =
  { dummy: Int
  }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  case location.hash of
    "" ->
      Model [location] []
        ! [ Navigation.newUrl "/#/" ]

    _ ->
      Model [location] []
        ! []



-- UPDATE


type Msg
  = NewUrl String
  | UrlChange Navigation.Location


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewUrl url ->
      model ! [ Navigation.newUrl url ]

    UrlChange location ->
      { model | history = location :: model.history }
        ! []


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

header : Html Msg
header =
  nav [ class "navbar navbar-light" ]
    [ div [ class "container" ]
      [ a [ class "navbar-brand", href "/#/" ]
        [ text "conduit" ]
      , ul [ class "nav navbar-nav pull-xs-right" ]
        [ headerLink "/#/" "Home" Nothing
        , headerLink "/#/" "New Post" (Just "ion-compose")
        , headerLink "/#/settings" "Settings" (Just "ion-gear-a")
        , headerLink "/#/register" "Sign Up" Nothing
        ]
      ]
    ]

headerLink : String -> String -> Maybe String -> Html Msg
headerLink destination message icon =
  li [ class "nav-item" ]
    [ a [ class "nav-link", href destination ]
      [ i [ class <| Maybe.withDefault "" icon ]
        []
      , text message
      ]
    ]
  

footer_ : Html Msg
footer_ =
  footer []
    [ div [ class "container" ]
      [ a [ class "logo-font", href "/" ]
        [ text "conduit" ]
      , span [ class "attribution" ]
        [ text "An interactive learning project from "
        , a [ href "https://thinkster.io" ]
          [ text "Thinkster" ]
        , text ". Code & design licensed under MIT."
        ]
      ]
    ]

homeView : Html Msg
homeView =
  div [ class "home-page" ]
    [ div [ class "banner" ]
      [ div [ class "container" ]
        [ h1 [ class "logo-font" ]
          [ text "conduit" ]
        , p []
          [ text "A place to share your knowledge." ]
        ]
      ]
    , div [ class "container page" ]
      [ div [ class "row" ]
        [ div [ class "col-md-9" ]
          [ div [ class "feed-toggle" ]
            [ ul [ class "nav nav-pills outline-active" ]
              [ li [ class "nav-item" ]
                [ a [ class "nav-link disabled", href "" ]
                  [ text "Your Feed" ]
                ]
              , li [ class "nav-item" ]
                [ a [ class "nav-link active", href "" ]
                  [ text "Global Feed" ]
                ]
              ]
            ]
          , div [ class "article-preview" ]
            [ div [ class "article-meta" ]
              [ a [ href "profile.html" ]
                [ img [ src "http://i.imgur.com/Qr71crq.jpg" ]
                  []
                ]
              , div [ class "info" ]
                [ a [ class "author", href "" ]
                  [ text "Eric Simons" ]
                , span [ class "date" ]
                  [ text "January 20th" ]
                ]
              , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                [ i [ class "ion-heart" ]
                  []
                , text "29"
                ]
              ]
            , a [ class "preview-link", href "" ]
              [ h1 []
                [ text "How to build webapps that scale" ]
              , p []
                [ text "This is the description for the post." ]
              , span []
                [ text "Read more..." ]
              ]
            ]
          , div [ class "article-preview" ]
            [ div [ class "article-meta" ]
              [ a [ href "profile.html" ]
                [ img [ src "http://i.imgur.com/N4VcUeJ.jpg" ]
                  []
                ]
              , div [ class "info" ]
                [ a [ class "author", href "" ]
                  [ text "Albert Pai" ]
                , span [ class "date" ]
                  [ text "January 20th" ]
                ]
              , button [ class "btn btn-outline-primary btn-sm pull-xs-right" ]
                [ i [ class "ion-heart" ]
                  []
                , text "32"
                ]
              ]
            , a [ class "preview-link", href "" ]
              [ h1 []
                [ text "The song you won't ever stop singing. No matter how hard you try." ]
              , p []
                [ text "This is the description for the post." ]
              , span []
                [ text "Read more..." ]
              ]
            ]
          ]
        , div [ class "col-md-3" ]
          [ div [ class "sidebar" ]
            [ p []
              [ text "Popular Tags" ]
            , div [ class "tag-list" ]
              [ a [ class "tag-pill tag-default", href "" ]
                [ text "programming" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "javascript" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "emberjs" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "angularjs" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "react" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "mean" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "node" ]
              , a [ class "tag-pill tag-default", href "" ]
                [ text "rails" ]
              ]
            ]
          ]
        ]
      ]
    ]

authView : Html Msg
authView =
  div [ class "auth-page" ]
    [ div [ class "container page" ]
      [ div [ class "row" ]
        [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
          [ h1 [ class "text-xs-center" ]
            [ text "Sign up" ]
          , p [ class "text-xs-center" ]
            [ a [ href "" ]
              [ text "Have an account?" ]
            ]
          , ul [ class "error-messages" ]
            [ li []
              [ text "That email is already taken" ]
            ]
          , Html.form []
            [ fieldset [ class "form-group" ]
              [ input [ class "form-control form-control-lg", placeholder "Your Name", type_ "text" ]
                []
              ]
            , fieldset [ class "form-group" ]
              [ input [ class "form-control form-control-lg", placeholder "Email", type_ "text" ]
                []
              ]
            , fieldset [ class "form-group" ]
              [ input [ class "form-control form-control-lg", placeholder "Password", type_ "password" ]
                []
              ]
            , button [ class "btn btn-lg btn-primary pull-xs-right" ]
              [ text "Sign up" ]
            ]
          ]
        ]
      ]
    ]

settingsView : Html Msg
settingsView =
  div [ class "settings-page" ]
    [ div [ class "container page" ]
      [ div [ class "row" ]
        [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
          [ h1 [ class "text-xs-center" ]
            [ text "Your Settings" ]
          , Html.form []
            [ fieldset []
              [ fieldset [ class "form-group" ]
                [ input [ class "form-control", placeholder "URL of profile picture", type_ "text" ]
                  []
                ]
              , fieldset [ class "form-group" ]
                [ input [ class "form-control form-control-lg", placeholder "Your Name", type_ "text" ]
                  []
                ]
              , fieldset [ class "form-group" ]
                [ textarea [ class "form-control form-control-lg", placeholder "Short bio about you", attribute "rows" "8" ]
                  []
                ]
              , fieldset [ class "form-group" ]
                [ input [ class "form-control form-control-lg", placeholder "Email", type_ "text" ]
                  []
                ]
              , fieldset [ class "form-group" ]
                [ input [ class "form-control form-control-lg", placeholder "Password", type_ "password" ]
                  []
                ]
              , button [ class "btn btn-lg btn-primary pull-xs-right" ]
                [ text "Update Settings" ]
              ]
            ]
          ]
        ]
      ]
    ]

view : Model -> Html Msg
view model =
  div []
    [ header
    , pageGivenHistory model.history
    , footer_
    ]

pageGivenHistory : List Navigation.Location -> Html Msg
pageGivenHistory history =
  case history of
    [] ->
      h2 [] [ text "No History" ]

    location :: _ ->
      hashToView location.hash
      

hashToView : String -> Html Msg
hashToView route =
  case route of
    "#/" ->
      homeView
      
    "#/register" ->
      authView

    "#/settings" ->
      settingsView

    _ ->
      h2 [] [ text "404" ]
