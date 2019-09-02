import Browser
import Html exposing (Html, text, pre)
import Http



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type Model
  = Failure String
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      , expect = Http.expectString GotText
      }
  )



-- UPDATE


type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err errMsg ->
          let
            errText =
              case errMsg of
                Http.BadUrl message ->
                  message

                Http.Timeout ->
                  "The HTTP request timed out"

                Http.NetworkError ->
                  "Something went wrong w/ the network"

                Http.BadStatus statusCode ->
                  "Bad status code " ++ String.fromInt statusCode

                Http.BadBody bodyExplanation ->
                  "Something went wrong: " ++ bodyExplanation
          in
            (Failure errText, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure errMsg ->
      text ("I was unable to load your book: " ++ errMsg)

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]
