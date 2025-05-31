defmodule LtiGGBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LtiGGBackendWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:lti_gg_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LtiGGBackend.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LtiGGBackend.Finch},
      # Start a worker by calling: LtiGGBackend.Worker.start_link(arg)
      # {LtiGGBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      LtiGGBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LtiGGBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LtiGGBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
