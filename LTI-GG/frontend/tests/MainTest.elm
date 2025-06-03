module MainTest exposing (all)

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
    describe "Main.update"
        [ test "Login with valid credentials sets loggedIn to True and loading to True" <|
            \_ ->
                let
                    modelWithCredentials =
                        { initModel | username = "admin", password = "admin123" }

                    ( updated, _ ) =
                        update Login modelWithCredentials
                in
                Expect.equal ( True, True ) ( updated.loggedIn, updated.loading )
        , test "Logout sets loggedIn to False, clears jobs/apps, error, and loading" <|
            \_ ->
                let
                    model =
                        { initModel | loggedIn = True, jobs = [], applications = [], error = Just "err", loading = True }

                    ( updated, _ ) =
                        update Logout model
                in
                Expect.all
                    [ \m -> Expect.equal False m.loggedIn
                    , \m -> Expect.equal [] m.jobs
                    , \m -> Expect.equal [] m.applications
                    , \m -> Expect.equal Nothing m.error
                    , \m -> Expect.equal False m.loading
                    ]
                    updated
        , test "FetchJobs sets loading to True" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update FetchJobs initModel
                in
                Expect.equal True updated.loading
        , test "JobsFetched Ok sets jobs, clears error and loading" <|
            \_ ->
                let
                    jobs =
                        [ { id = "1", title = "t", description = "d", status = "open" } ]

                    ( updated, _ ) =
                        update (JobsFetched (Ok jobs)) { initModel | loading = True }
                in
                Expect.equal ( jobs, Nothing, False ) ( updated.jobs, updated.error, updated.loading )
        , test "JobsFetched Err sets error and loading to False" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (JobsFetched (Err (Http.BadUrl ""))) { initModel | loading = True }
                in
                Expect.equal ( Just "Failed to fetch jobs", False ) ( updated.error, updated.loading )
        , test "FetchApplications sets loading to True" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update FetchApplications initModel
                in
                Expect.equal True updated.loading
        , test "ApplicationsFetched Ok sets applications, clears error and loading" <|
            \_ ->
                let
                    apps =
                        [ { id = "1", candidate_id = "c", job_id = "j", status = "applied" } ]

                    ( updated, _ ) =
                        update (ApplicationsFetched (Ok apps)) { initModel | loading = True }
                in
                Expect.equal ( apps, Nothing, False ) ( updated.applications, updated.error, updated.loading )
        , test "ApplicationsFetched Err sets error and loading to False" <|
            \_ ->
                let
                    ( updated, _ ) =
                        update (ApplicationsFetched (Err (Http.BadUrl ""))) { initModel | loading = True }
                in
                Expect.equal ( Just "Failed to fetch applications", False ) ( updated.error, updated.loading )
        ]
