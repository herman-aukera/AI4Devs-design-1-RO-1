defmodule LtiGGBackendWeb.ApplicationController do
  use LtiGGBackendWeb, :controller
  alias LtiGgBackend.Application.ApplicationApp
  alias LtiGgBackend.Infrastructure.ApplicationRepo
  alias LtiGgBackend.Domain.Application

  def index(conn, _params) do
    applications = ApplicationRepo.all()
    json(conn, Enum.map(applications, &app_to_map/1))
  end

  def create(conn, %{"id" => id, "candidate_id" => candidate_id, "job_id" => job_id}) do
    app = ApplicationApp.create_application(id, candidate_id, job_id)
    :ok = ApplicationRepo.put(app)
    json(conn, app_to_map(app))
  end

  def update_status(conn, %{"id" => id, "status" => status_str}) do
    with %Application{} = app <- ApplicationRepo.get(id),
         {:ok, status} <- parse_status(status_str) do
      updated = ApplicationApp.change_application_status(app, status)
      :ok = ApplicationRepo.put(updated)
      json(conn, app_to_map(updated))
    else
      nil -> send_resp(conn, 404, "Not found")
      {:error, :invalid_status} -> send_resp(conn, 400, "Invalid status")
    end
  end

  defp app_to_map(%Application{id: id, candidate_id: candidate_id, job_id: job_id, status: status}) do
    %{id: id, candidate_id: candidate_id, job_id: job_id, status: status}
  end

  defp parse_status(str) do
    case String.to_existing_atom(str) do
      s when s in [:submitted, :reviewed, :rejected, :accepted] -> {:ok, s}
      _ -> {:error, :invalid_status}
    end
  rescue
    ArgumentError -> {:error, :invalid_status}
  end
end
