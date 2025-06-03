module Application exposing (Model, Msg(..), init, update)

-- MODEL
type alias Model =
    { name : String
    , email : String
    , resume : String
    , submitting : Bool
    , error : Maybe String
    , success : Bool
    }

init : Model
init =
    { name = ""
    , email = ""
    , resume = ""
    , submitting = False
    , error = Nothing
    , success = False
    }

-- MSG
type Msg
    = UpdateName String
    | UpdateEmail String
    | UpdateResume String
    | Submit
    | SubmissionSuccess
    | SubmissionFailure String

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateName name ->
            ( { model | name = name }, Cmd.none )

        UpdateEmail email ->
            ( { model | email = email }, Cmd.none )

        UpdateResume resume ->
            ( { model | resume = resume }, Cmd.none )

        Submit ->
            ( { model | submitting = True, error = Nothing }, Cmd.none )

        SubmissionSuccess ->
            ( { model | submitting = False, success = True }, Cmd.none )

        SubmissionFailure err ->
            ( { model | submitting = False, error = Just err }, Cmd.none )
