module Main exposing (main, Model, update, Msg(..))

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (..)

main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model =
    { loggedIn : Bool }

init : Model
init =
    { loggedIn = False }

-- UPDATE

type Msg
    = Login
    | Logout

update : Msg -> Model -> Model
update msg model =
    case msg of
        Login ->
            { model | loggedIn = True }
        Logout ->
            { model | loggedIn = False }

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ if model.loggedIn then
            div [] [ text "Welcome, admin!" ]
          else
            div [] [ text "Please log in (admin/admin123)" ]
        ]
