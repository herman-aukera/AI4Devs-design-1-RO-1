module Main exposing (Model, Msg(..), main, update)

import Browser
import Css exposing (alignItems, auto, backgroundColor, block, bold, border3, borderBottom3, borderColor, borderRadius, borderStyle, borderWidth, boxShadow3, center, color, cursor, display, displayFlex, focus, fontSize, fontStyle, fontWeight, height, hex, hover, italic, justifyContent, margin2, marginBottom, marginTop, maxWidth, none, outline, padding2, paddingLeft, pct, pointer, property, px, rgba, sansSerif, solid, spaceBetween, textAlign, width, zero)
import Css.Global exposing (global)
import Html.Styled as Html exposing (Html, button, div, form, h1, h2, input, li, text, toUnstyled, ul)
import Html.Styled.Attributes as Attr exposing (css, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Styles


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = toUnstyledView, subscriptions = \_ -> Sub.none }


toUnstyledView =
    toUnstyled << view



-- MODEL


type alias Job =
    { id : String
    , title : String
    , description : String
    , status : String
    }


type alias Application =
    { id : String
    , candidate_id : String
    , job_id : String
    , status : String
    }


type alias Model =
    { loggedIn : Bool
    , jobs : List Job
    , applications : List Application
    , error : Maybe String
    , loading : Bool
    , newJob : JobForm
    , newApp : AppForm
    , username : String
    , password : String
    }


type alias JobForm =
    { id : String, title : String, description : String }


type alias AppForm =
    { id : String, candidate_id : String, job_id : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { loggedIn = False
      , jobs = []
      , applications = []
      , error = Nothing
      , loading = False
      , newJob = { id = "", title = "", description = "" }
      , newApp = { id = "", candidate_id = "", job_id = "" }
      , username = ""
      , password = ""
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Login
    | Logout
    | UpdateUsername String
    | UpdatePassword String
    | FetchJobs
    | JobsFetched (Result Http.Error (List Job))
    | FetchApplications
    | ApplicationsFetched (Result Http.Error (List Application))
    | UpdateNewJobId String
    | UpdateNewJobTitle String
    | UpdateNewJobDesc String
    | SubmitNewJob
    | JobCreated (Result Http.Error Job)
    | DeleteJob String
    | JobDeleted (Result Http.Error String)
    | UpdateNewAppId String
    | UpdateNewAppCandidate String
    | UpdateNewAppJob String
    | SubmitNewApp
    | AppCreated (Result Http.Error Application)
    | DeleteApp String
    | AppDeleted (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login ->
            if model.username == "admin" && model.password == "admin123" then
                ( { model | loggedIn = True, loading = True, error = Nothing }, Cmd.batch [ fetchJobs, fetchApplications ] )

            else
                ( { model | error = Just "Invalid username or password" }, Cmd.none )

        Logout ->
            ( { model | loggedIn = False, jobs = [], applications = [], error = Nothing, loading = False, username = "", password = "" }, Cmd.none )

        UpdateUsername username ->
            ( { model | username = username }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        FetchJobs ->
            ( { model | loading = True }, fetchJobs )

        JobsFetched (Ok jobs) ->
            ( { model | jobs = jobs, error = Nothing, loading = False }, Cmd.none )

        JobsFetched (Err _) ->
            ( { model | error = Just "Failed to fetch jobs", loading = False }, Cmd.none )

        FetchApplications ->
            ( { model | loading = True }, fetchApplications )

        ApplicationsFetched (Ok applications) ->
            ( { model | applications = applications, error = Nothing, loading = False }, Cmd.none )

        ApplicationsFetched (Err _) ->
            ( { model | error = Just "Failed to fetch applications", loading = False }, Cmd.none )

        UpdateNewJobId v ->
            ( { model | newJob = { id = v, title = model.newJob.title, description = model.newJob.description } }, Cmd.none )

        UpdateNewJobTitle v ->
            ( { model | newJob = { id = model.newJob.id, title = v, description = model.newJob.description } }, Cmd.none )

        UpdateNewJobDesc v ->
            ( { model | newJob = { id = model.newJob.id, title = model.newJob.title, description = v } }, Cmd.none )

        SubmitNewJob ->
            let
                body =
                    Http.jsonBody <| Encode.object [ ( "id", Encode.string model.newJob.id ), ( "title", Encode.string model.newJob.title ), ( "description", Encode.string model.newJob.description ) ]
            in
            ( model, Http.post { url = "http://localhost:4000/api/jobs", body = body, expect = Http.expectJson JobCreated jobDecoder } )

        JobCreated (Ok job) ->
            ( { model | jobs = job :: model.jobs, newJob = { id = "", title = "", description = "" }, error = Nothing }, Cmd.none )

        JobCreated (Err _) ->
            ( { model | error = Just "Failed to create job" }, Cmd.none )

        DeleteJob jid ->
            ( model, Http.request { method = "DELETE", url = "http://localhost:4000/api/jobs/" ++ jid, body = Http.emptyBody, expect = Http.expectString (\result -> JobDeleted (Result.map (always jid) result)), headers = [], timeout = Nothing, tracker = Nothing } )

        JobDeleted (Ok jid) ->
            ( { model | jobs = List.filter (\j -> j.id /= jid) model.jobs }, Cmd.none )

        JobDeleted (Err _) ->
            ( { model | error = Just "Failed to delete job" }, Cmd.none )

        UpdateNewAppId v ->
            ( { model | newApp = { id = v, candidate_id = model.newApp.candidate_id, job_id = model.newApp.job_id } }, Cmd.none )

        UpdateNewAppCandidate v ->
            ( { model | newApp = { id = model.newApp.id, candidate_id = v, job_id = model.newApp.job_id } }, Cmd.none )

        UpdateNewAppJob v ->
            ( { model | newApp = { id = model.newApp.id, candidate_id = model.newApp.candidate_id, job_id = v } }, Cmd.none )

        SubmitNewApp ->
            let
                body =
                    Http.jsonBody <| Encode.object [ ( "id", Encode.string model.newApp.id ), ( "candidate_id", Encode.string model.newApp.candidate_id ), ( "job_id", Encode.string model.newApp.job_id ) ]
            in
            ( model, Http.post { url = "http://localhost:4000/api/applications", body = body, expect = Http.expectJson AppCreated applicationDecoder } )

        AppCreated (Ok app) ->
            ( { model | applications = app :: model.applications, newApp = { id = "", candidate_id = "", job_id = "" }, error = Nothing }, Cmd.none )

        AppCreated (Err _) ->
            ( { model | error = Just "Failed to create application" }, Cmd.none )

        DeleteApp aid ->
            ( model, Http.request { method = "DELETE", url = "http://localhost:4000/api/applications/" ++ aid, body = Http.emptyBody, expect = Http.expectString (\result -> AppDeleted (Result.map (always aid) result)), headers = [], timeout = Nothing, tracker = Nothing } )

        AppDeleted (Ok aid) ->
            ( { model | applications = List.filter (\a -> a.id /= aid) model.applications }, Cmd.none )

        AppDeleted (Err _) ->
            ( { model | error = Just "Failed to delete application" }, Cmd.none )



-- HTTP


fetchJobs : Cmd Msg
fetchJobs =
    Http.get
        { url = "http://localhost:4000/api/jobs"
        , expect = Http.expectJson JobsFetched jobsDecoder
        }


fetchApplications : Cmd Msg
fetchApplications =
    Http.get
        { url = "http://localhost:4000/api/applications"
        , expect = Http.expectJson ApplicationsFetched applicationsDecoder
        }


jobsDecoder : Decode.Decoder (List Job)
jobsDecoder =
    Decode.list jobDecoder


jobDecoder : Decode.Decoder Job
jobDecoder =
    Decode.map4 Job
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "status" Decode.string)


applicationDecoder : Decode.Decoder Application
applicationDecoder =
    Decode.map4 Application
        (Decode.field "id" Decode.string)
        (Decode.field "candidate_id" Decode.string)
        (Decode.field "job_id" Decode.string)
        (Decode.field "status" Decode.string)


applicationsDecoder : Decode.Decoder (List Application)
applicationsDecoder =
    Decode.list applicationDecoder



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.div Styles.container
            [ h1 Styles.h1 [ text "LTI ATS Dashboard" ]
            , if model.loggedIn then
                dashboardView model

              else
                loginView model
            ]
        ]


loginView : Model -> Html Msg
loginView model =
    Html.div [ Attr.css [ marginTop (px 60), textAlign Css.center, maxWidth (px 400), margin2 zero auto ] ]
        [ h2 Styles.h2 [ text "Login" ]
        , Html.form [ onSubmit Login, Attr.css [ marginTop (px 24) ] ]
            [ Html.input
                (Styles.input
                    ++ [ Attr.placeholder "Username"
                       , Attr.value model.username
                       , onInput UpdateUsername
                       , Attr.type_ "text"
                       , Attr.css [ width (pct 100), marginBottom (px 12) ]
                       ]
                )
                []
            , Html.input
                (Styles.input
                    ++ [ Attr.placeholder "Password"
                       , Attr.value model.password
                       , onInput UpdatePassword
                       , Attr.type_ "password"
                       , Attr.css [ width (pct 100), marginBottom (px 16) ]
                       ]
                )
                []
            , button
                (Styles.button
                    ++ [ Attr.type_ "submit"
                       , Attr.attribute "aria-label" "Login"
                       , Attr.css [ width (pct 100) ]
                       ]
                )
                [ text "Login" ]
            ]
        , Html.div [ Attr.css [ marginTop (px 12), fontSize (px 14), color (hex "#666") ] ]
            [ text "Default credentials: admin / admin123" ]
        , case model.error of
            Just err ->
                Html.div Styles.errorText [ text err ]

            Nothing ->
                Html.text ""
        ]


dashViewSection : String -> Html msg -> Html msg
dashViewSection title content =
    Html.section
        [ Attr.css [ marginTop (px 32), backgroundColor (hex "#f3f4f6"), borderRadius (px 8), padding2 (px 16) (px 16), boxShadow3 (px 0) (px 2) (rgba 0 0 0 0.07) ]
        , Attr.attribute "aria-labelledby" title
        ]
        [ h2 Styles.h2 [ text title ]
        , content
        ]


dashViewList : List (Html msg) -> Html msg



-- Empty state for lists


dashViewList items =
    if List.isEmpty items then
        Html.div [ Attr.css [ color (hex "#888"), fontStyle italic, marginTop (px 8) ] ] [ text "No items found." ]

    else
        ul [ Attr.css [ paddingLeft (px 0), marginTop (px 8) ] ] items


dashViewJobForm model =
    Html.form [ Attr.css [ marginBottom (px 16) ], onSubmit SubmitNewJob ]
        [ Html.input (Styles.input ++ [ Attr.placeholder "Job ID", Attr.value model.newJob.id, onInput UpdateNewJobId ]) []
        , Html.input (Styles.input ++ [ Attr.placeholder "Title", Attr.value model.newJob.title, onInput UpdateNewJobTitle ]) []
        , Html.input (Styles.input ++ [ Attr.placeholder "Description", Attr.value model.newJob.description, onInput UpdateNewJobDesc ]) []
        , button (Styles.button ++ [ Attr.type_ "submit" ]) [ text "Add Job" ]
        ]


dashViewAppForm model =
    Html.form [ Attr.css [ marginBottom (px 16) ], onSubmit SubmitNewApp ]
        [ Html.input (Styles.input ++ [ Attr.placeholder "App ID", Attr.value model.newApp.id, onInput UpdateNewAppId ]) []
        , Html.input (Styles.input ++ [ Attr.placeholder "Candidate ID", Attr.value model.newApp.candidate_id, onInput UpdateNewAppCandidate ]) []
        , Html.input (Styles.input ++ [ Attr.placeholder "Job ID", Attr.value model.newApp.job_id, onInput UpdateNewAppJob ]) []
        , button (Styles.button ++ [ Attr.type_ "submit" ]) [ text "Add Application" ]
        ]


dashboardView model =
    Html.div []
        [ Html.div [ Attr.css [ displayFlex, justifyContent spaceBetween, alignItems center, marginBottom (px 16) ] ]
            [ Html.div [] [ Html.text "Welcome, admin!" ]
            , button (Styles.button ++ [ onClick Logout, Attr.attribute "aria-label" "Logout" ]) [ text "Logout" ]
            ]
        , if model.loading then
            Html.div [ Attr.css [ marginTop (px 24) ] ] [ text "Loading..." ]

          else
            Html.div []
                [ dashViewSection "Jobs"
                    (Html.div [] [ dashViewJobForm model, dashViewList (List.map (jobItemView model) model.jobs) ])
                , dashViewSection "Applications"
                    (Html.div [] [ dashViewAppForm model, dashViewList (List.map (applicationItemView model) model.applications) ])
                ]
        , case model.error of
            Just err ->
                Html.div Styles.errorText [ text err ]

            Nothing ->
                Html.text ""
        ]


jobItemView : Model -> Job -> Html Msg
jobItemView _ job =
    li (Styles.listItem ++ [ Attr.attribute "role" "listitem", Attr.css [ backgroundColor (hex "#f9fafb"), borderRadius (px 6), marginBottom (px 8), boxShadow3 (px 0) (px 1) (rgba 0 0 0 0.03), padding2 (px 10) (px 12) ] ])
        [ Html.div [ Attr.css [ fontWeight bold, fontSize (px 18), color (hex "#22223b") ] ] [ text job.title ]
        , Html.div [ Attr.css [ color (hex "#555"), fontSize (px 14), marginTop (px 2) ] ] [ text job.description ]
        , Html.div [ Attr.css [ color (hex "#666"), fontSize (px 13), marginTop (px 2) ] ] [ text ("Status: " ++ job.status) ]
        , button (Styles.button ++ [ onClick (DeleteJob job.id), Attr.attribute "aria-label" "Delete Job" ]) [ text "Delete" ]
        ]


applicationItemView model app =
    li (Styles.listItem ++ [ Attr.attribute "role" "listitem", Attr.css [ backgroundColor (hex "#f9fafb"), borderRadius (px 6), marginBottom (px 8), boxShadow3 (px 0) (px 1) (rgba 0 0 0 0.03), padding2 (px 10) (px 12) ] ])
        [ Html.div [ Attr.css [ fontWeight bold, fontSize (px 16), color (hex "#4a4e69") ] ] [ text ("Application ID: " ++ app.id) ]
        , Html.div [ Attr.css [ color (hex "#555"), fontSize (px 14), marginTop (px 2) ] ] [ text ("Candidate: " ++ app.candidate_id) ]
        , Html.div [ Attr.css [ color (hex "#555"), fontSize (px 14), marginTop (px 2) ] ] [ text ("Job: " ++ app.job_id) ]
        , Html.div [ Attr.css [ color (hex "#666"), fontSize (px 13), marginTop (px 2) ] ] [ text ("Status: " ++ app.status) ]
        , button (Styles.button ++ [ onClick (DeleteApp app.id), Attr.attribute "aria-label" "Delete Application" ]) [ text "Delete" ]
        ]
