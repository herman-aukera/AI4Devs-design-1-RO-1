defmodule LtiGGBackendWeb.Router do
  use LtiGGBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LtiGGBackendWeb do
    pipe_through :api

    get "/candidates", CandidateController, :index
    post "/candidates", CandidateController, :create
    patch "/candidates/:id/status", CandidateController, :update_status

    get "/jobs", JobController, :index
    post "/jobs", JobController, :create
    patch "/jobs/:id/status", JobController, :update_status

    get "/applications", ApplicationController, :index
    post "/applications", ApplicationController, :create
    patch "/applications/:id/status", ApplicationController, :update_status
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:lti_gg_backend, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
