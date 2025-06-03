module JobFetchTest exposing (all)

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
    describe "Job fetch update logic"
        [ test "Login triggers job fetch and sets loggedIn to True" <|
            \_ ->
                let
                    loginModel =
                        { initModel | username = "admin", password = "admin123" }

                    ( model, _ ) =
                        update Login loginModel
                in
                Expect.equal True model.loggedIn
        , test "JobsFetched Ok updates jobs in model" <|
            \_ ->
                let
                    jobs =
                        [ { id = "1", title = "Backend", description = "API", status = "open" } ]

                    ( model, _ ) =
                        update (JobsFetched (Ok jobs)) { initModel | loggedIn = True }
                in
                Expect.equal jobs model.jobs
        , test "JobsFetched Err sets error in model" <|
            \_ ->
                let
                    ( model, _ ) =
                        update (JobsFetched (Err (Http.BadUrl ""))) { initModel | loggedIn = True }
                in
                Expect.equal (Just "Failed to fetch jobs") model.error
        ]
