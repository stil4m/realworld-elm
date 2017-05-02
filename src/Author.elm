module Author exposing (Author, decoder)

import Json.Decode as JD exposing (Decoder)
import Json.Decode.Extra as JD exposing ((|:))


type alias Author =
    { username : String
    , image : String
    , bio : Maybe String
    , following : Bool
    }


decoder : Decoder Author
decoder =
    JD.succeed Author
        |: JD.field "username" JD.string
        |: JD.field "image" JD.string
        |: JD.field "bio" (JD.maybe JD.string)
        |: JD.field "following" JD.bool
