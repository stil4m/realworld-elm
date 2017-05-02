module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import TagList
import Date.Extra.Config.Config_en_gb as EnGb
import Date.Extra.Format as DF
import Article exposing (Article)
import RemoteData as RD exposing (RemoteData)
import Http
import Api


main : Program Never Model Msg
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
    , articles : RemoteData Http.Error (List Article)
    , tagList : TagList.Model
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    case location.hash of
        "" ->
            let
                ( tagList, tagListCmds ) =
                    TagList.init
            in
                Model [ location ] RD.Loading tagList
                    ! [ Navigation.newUrl "/#/"
                      , Cmd.map TagListMsg tagListCmds
                      , Api.articles OnArticles { offset = 0, limit = 10 }
                      ]

        _ ->
            let
                ( tagList, tagListCmds ) =
                    TagList.init
            in
                Model [ location ] RD.Loading tagList
                    ! [ Cmd.map TagListMsg tagListCmds
                      , Api.articles OnArticles { offset = 0, limit = 10 }
                      ]



-- UPDATE


type Msg
    = NewUrl String
    | UrlChange Navigation.Location
    | TagListMsg TagList.Msg
    | OnArticles (RemoteData Http.Error (List Article))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            model ! [ Navigation.newUrl url ]

        UrlChange location ->
            { model | history = location :: model.history }
                ! []

        TagListMsg subMsg ->
            let
                ( newTagList, tagListCmds ) =
                    TagList.update subMsg model.tagList
            in
                ( { model | tagList = newTagList }
                , Cmd.none
                )

        OnArticles articles ->
            ( { model | articles = articles }, Cmd.none )



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


homeView : Model -> Html Msg
homeView model =
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
                    , div []
                        [ case model.articles of
                            RD.Loading ->
                                div [] [ text "Loading articles..." ]

                            RD.NotAsked ->
                                div [] [ text "No articles are here... yet." ]

                            RD.Success articles ->
                                div [] (List.map articlePreview articles)

                            RD.Failure e ->
                                text <| "Something went wrong..." ++ toString e
                        ]
                    ]
                , div [ class "col-md-3" ]
                    [ div [ class "sidebar" ]
                        [ TagList.view model.tagList |> Html.map TagListMsg ]
                    ]
                ]
            ]
        ]


articlePreview : Article -> Html Msg
articlePreview article =
    div [ class "article-preview" ]
        [ div [ class "article-meta" ]
            [ a [ href "profile.html" ]
                [ img [ src article.author.image ]
                    []
                ]
            , div [ class "info" ]
                [ a [ class "author", href "" ]
                    [ text article.author.username ]
                , span [ class "date" ]
                    [ text (DF.format EnGb.config "%B %e, %Y" article.createdAt) ]
                ]
            , button
                [ classList
                    [ ( "btn btn-outline-primary btn-sm pull-xs-right", True )
                    , ( "btn-primary", article.favorited )
                    ]
                ]
                [ i [ class "ion-heart" ]
                    []
                , text (toString article.favoritesCount)
                ]
            ]
        , a [ class "preview-link", href "" ]
            [ h1 []
                [ text article.title ]
            , p []
                [ text article.description ]
            , span []
                [ text "Read more..." ]
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
        , pageGivenHistory model model.history
        , footer_
        ]


pageGivenHistory : Model -> List Navigation.Location -> Html Msg
pageGivenHistory model history =
    case history of
        [] ->
            h2 [] [ text "No History" ]

        location :: _ ->
            hashToView model location.hash


hashToView : Model -> String -> Html Msg
hashToView model route =
    case route of
        "#/" ->
            homeView model

        "#/register" ->
            authView

        "#/settings" ->
            settingsView

        _ ->
            h2 [] [ text "404" ]
