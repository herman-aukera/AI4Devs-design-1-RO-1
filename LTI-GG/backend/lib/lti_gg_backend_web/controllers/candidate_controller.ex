defmodule LtiGGBackendWeb.CandidateController do
  use LtiGGBackendWeb, :controller
  alias LtiGgBackend.Application.CandidateApp
  alias LtiGgBackend.Infrastructure.CandidateRepo
  alias LtiGgBackend.Domain.Candidate

  @moduledoc """
  Web controller for Candidate API endpoints.
  Handles JSON requests for listing, creating, and updating candidates.
  Follows Clean Architecture: delegates to Application and Infrastructure layers.
  """

  # OPTIONS /api/candidates (for CORS preflight)
  def options(conn, _params) do
    send_resp(conn, 200, "")
  end

  # GET /api/candidates
  def index(conn, _params) do
    candidates = CandidateRepo.all()
    json(conn, Enum.map(candidates, &candidate_to_map/1))
  end

  # POST /api/candidates
  def create(conn, %{"id" => id, "name" => name, "email" => email}) do
    candidate = CandidateApp.create_candidate(id, name, email)
    :ok = CandidateRepo.put(candidate)

    conn
    |> put_status(:created)
    |> json(candidate_to_map(candidate))
  end

  # PATCH /api/candidates/:id/status
  def update_status(conn, %{"id" => id, "status" => status_str}) do
    with %Candidate{} = candidate <- CandidateRepo.get(id),
         {:ok, status} <- parse_status(status_str) do
      updated = CandidateApp.change_candidate_status(candidate, status)
      :ok = CandidateRepo.put(updated)
      json(conn, candidate_to_map(updated))
    else
      nil -> send_resp(conn, 404, "Not found")
      {:error, :invalid_status} -> send_resp(conn, 400, "Invalid status")
    end
  end

  defp candidate_to_map(%Candidate{id: id, name: name, email: email, status: status}) do
    %{id: id, name: name, email: email, status: status}
  end

  defp parse_status(str) do
    case String.to_existing_atom(str) do
      s when s in [:applied, :screening, :interview, :offer, :hired, :rejected] -> {:ok, s}
      _ -> {:error, :invalid_status}
    end
  rescue
    ArgumentError -> {:error, :invalid_status}
  end
end
