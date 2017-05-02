module Tag exposing (Tag, decoder)

import Json.Decode as JD exposing (Decoder)


type alias Tag =
    { name : String
    }


decoder : Decoder Tag
decoder =
    JD.map Tag JD.string
