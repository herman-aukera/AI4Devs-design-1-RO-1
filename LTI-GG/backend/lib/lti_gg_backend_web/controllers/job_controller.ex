defmodule LtiGGBackendWeb.JobController do
  use LtiGGBackendWeb, :controller
  alias LtiGgBackend.Application.JobApp
  alias LtiGgBackend.Infrastructure.JobRepo
  alias LtiGgBackend.Domain.Job

  def index(conn, _params) do
    jobs = JobRepo.all()
    json(conn, Enum.map(jobs, &job_to_map/1))
  end

  def create(conn, %{"id" => id, "title" => title, "description" => description}) do
    job = JobApp.create_job(id, title, description)
    :ok = JobRepo.put(job)
    json(conn, job_to_map(job))
  end

  def update_status(conn, %{"id" => id, "status" => status_str}) do
    with %Job{} = job <- JobRepo.get(id),
         {:ok, status} <- parse_status(status_str) do
      updated = JobApp.change_job_status(job, status)
      :ok = JobRepo.put(updated)
      json(conn, job_to_map(updated))
    else
      nil -> send_resp(conn, 404, "Not found")
      {:error, :invalid_status} -> send_resp(conn, 400, "Invalid status")
    end
  end

  defp job_to_map(%Job{id: id, title: title, description: description, status: status}) do
    %{id: id, title: title, description: description, status: status}
  end

  defp parse_status(str) do
    case String.to_existing_atom(str) do
      s when s in [:open, :closed] -> {:ok, s}
      _ -> {:error, :invalid_status}
    end
  rescue
    ArgumentError -> {:error, :invalid_status}
  end
end
