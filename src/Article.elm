module Article exposing (Article, decoder)

import Json.Decode as JD exposing (Decoder)
import Json.Decode.Extra as JD exposing ((|:))
import Date exposing (Date)
import Author exposing (Author)


type alias Article =
    { title : String
    , description : String
    , body : String
    , favorited : Bool
    , favoritesCount : Maybe Int
    , slug : String
    , tagList : List String
    , createdAt : Date
    , updatedAt : Date
    , author : Author
    }


decoder : Decoder Article
decoder =
    JD.succeed Article
        |: JD.field "title" JD.string
        |: JD.field "description" JD.string
        |: JD.field "body" JD.string
        |: JD.field "favorited" JD.bool
        -- This field is sometimes not present in the response (server bug IMHO)
        |: (JD.maybe (JD.field "favoritesCount" JD.int))
        |: (JD.field "slug" JD.string)
        |: (JD.field "tagList" (JD.list JD.string))
        |: (JD.field "createdAt" (JD.date))
        |: (JD.field "updatedAt" (JD.date))
        |: (JD.field "author" Author.decoder)
