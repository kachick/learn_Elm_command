module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (..)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { input : String, result : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "", result = "" }, Cmd.none )


type Msg
    = Click
    | Input String
    | GotRepro (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            ( { model | input = input }, Cmd.none )

        Click ->
            ( model
            , Http.get
                { url = "https://api.github.com/repos/" ++ model.input, expect = Http.expectString GotRepro }
            )

        GotRepro (Ok repo) ->
            ( { model | result = repo }, Cmd.none )

        GotRepro (Err error) ->
            ( { model | result = Debug.toString error }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ input [ value model.input, onInput Input, placeholder "elm/core" ] []
        , button [ onClick Click ] [ text "Get Respository Info" ]
        , p [] [ text model.result ]
        ]
