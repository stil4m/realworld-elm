module TagList exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import RemoteData
import RemoteData as RD exposing (RemoteData)
import Api
import Tag exposing (Tag)


type alias Model =
    RemoteData Http.Error (List Tag)


type Msg
    = OnTags (RemoteData Http.Error (List Tag))


init : ( Model, Cmd Msg )
init =
    ( RD.Loading
    , Api.tags OnTags
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnTags newModel ->
            ( newModel
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ p []
            [ text "Popular Tags" ]
        , div [ class "tag-list" ]
            [ case model of
                RD.NotAsked ->
                    span [] []

                RD.Loading ->
                    text "Loading tags..."

                RD.Success tags ->
                    div [] (List.map viewTag tags)

                RD.Failure f ->
                    text "Something has gone wrong while loading the tags..."
            ]
        ]


viewTag : Tag -> Html Msg
viewTag tag =
    a [ class "tag-pill tag-default", href "" ]
        [ text tag.name ]
