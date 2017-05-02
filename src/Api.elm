module Api exposing (tags, articles)

import Tag exposing (Tag)
import Article exposing (Article)
import Json.Decode as JD
import Http
import HttpBuilder
import RemoteData as RD exposing (RemoteData)
import Task


baseUrl : String
baseUrl =
    "https://conduit.productionready.io/api"


type alias Pagination =
    { offset : Int
    , limit : Int
    }


articles : (RemoteData Http.Error (List Article) -> msg) -> Pagination -> Cmd msg
articles tagger pagination =
    HttpBuilder.get (baseUrl ++ "/articles")
        |> HttpBuilder.withExpect
            (Http.expectJson (JD.at [ "articles" ] (JD.list Article.decoder)))
        |> HttpBuilder.withQueryParams
            [ ( "limit", toString pagination.limit )
            , ( "offset", toString pagination.offset )
            ]
        |> HttpBuilder.withCacheBuster "_cb"
        |> HttpBuilder.toTask
        |> RD.fromTask
        |> Task.perform tagger


tags : (RemoteData Http.Error (List Tag) -> msg) -> Cmd msg
tags tagger =
    HttpBuilder.get (baseUrl ++ "/tags")
        |> HttpBuilder.withExpect
            (Http.expectJson (JD.at [ "tags" ] (JD.list Tag.decoder)))
        |> HttpBuilder.withCacheBuster "_cb"
        |> HttpBuilder.toTask
        |> RD.fromTask
        |> Task.perform tagger
