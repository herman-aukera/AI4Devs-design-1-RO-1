module MainTest exposing (all)

import Test exposing (..)
import Expect
import Main exposing (Model, update, Msg(..))

all : Test
all =
    describe "Main.update"
        [ test "Login sets loggedIn to True" <|
            \_ ->
                let
                    model = { loggedIn = False }
                    updated = update Login model
                in
                Expect.equal True updated.loggedIn
        , test "Logout sets loggedIn to False" <|
            \_ ->
                let
                    model = { loggedIn = True }
                    updated = update Logout model
                in
                Expect.equal False updated.loggedIn
        ]
