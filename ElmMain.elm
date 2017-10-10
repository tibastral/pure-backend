port module ElmMain exposing (..)

import Json.Decode exposing (..)


type alias HttpResponse =
    { result : String
    , statusCode : Int
    , contentType : String
    }


port done : HttpResponse -> Cmd msg


port sendData : (Flags -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceiveFlags flags ->
            ( model, done { result = "Ok", statusCode = 200, contentType = "text/plain" } )


type alias Model =
    String


type alias Flags =
    { response : String }


init : ( Model, Cmd Msg )
init =
    ( "Hello from elm", Cmd.none )


type Msg
    = ReceiveFlags Flags


subscriptions : Model -> Sub Msg
subscriptions model =
    sendData ReceiveFlags


main : Program Never Model Msg
main =
    Platform.program { init = init, update = update, subscriptions = subscriptions }
