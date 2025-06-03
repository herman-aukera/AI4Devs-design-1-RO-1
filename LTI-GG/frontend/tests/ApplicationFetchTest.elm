module ApplicationFetchTest exposing (all)

import Expect
import Http
import Main exposing (Model, Msg(..), update)
import Test exposing (..)


initModel : Model
initModel =
    { loggedIn = False
    , jobs = []
    , applications = []
    , error = Nothing
    , loading = False
    , newJob = { id = "", title = "", description = "" }
    , newApp = { id = "", candidate_id = "", job_id = "" }
    , username = ""
    , password = ""
    }


all : Test
all =
    describe "Application fetch update logic"
        [ test "Login triggers application fetch and sets loggedIn to True" <|
            \_ ->
                let
                    loginModel =
                        { initModel | username = "admin", password = "admin123" }

                    ( model, _ ) =
                        update Login loginModel
                in
                Expect.equal True model.loggedIn
        , test "ApplicationsFetched Ok updates applications in model" <|
            \_ ->
                let
                    apps =
                        [ { id = "1", candidate_id = "c1", job_id = "j1", status = "submitted" } ]

                    ( model, _ ) =
                        update (ApplicationsFetched (Ok apps)) { initModel | loggedIn = True }
                in
                Expect.equal apps model.applications
        , test "ApplicationsFetched Err sets error in model" <|
            \_ ->
                let
                    ( model, _ ) =
                        update (ApplicationsFetched (Err (Http.BadUrl ""))) { initModel | loggedIn = True }
                in
                Expect.equal (Just "Failed to fetch applications") model.error
        ]
