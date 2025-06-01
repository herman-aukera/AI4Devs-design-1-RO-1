defmodule LtiGGBackendWeb.JobControllerTest do
  use LtiGGBackendWeb.ConnCase, async: true
  alias LtiGgBackend.Infrastructure.JobRepo
  alias LtiGgBackend.Domain.Job

  setup do
    case Agent.start_link(fn -> %{} end, name: LtiGgBackend.Infrastructure.JobRepo) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
    JobRepo.reset()
    :ok
  end

  test "GET /api/jobs returns all jobs", %{conn: conn} do
    job = Job.new("j1", "Backend Dev", "Build APIs")
    :ok = JobRepo.put(job)
    conn = get(conn, "/api/jobs")
    assert json_response(conn, 200) == [%{"id" => "j1", "title" => "Backend Dev", "description" => "Build APIs", "status" => "open"}]
  end

  test "POST /api/jobs creates a job", %{conn: conn} do
    conn = post(conn, "/api/jobs", %{id: "j2", title: "Frontend Dev", description: "Build UIs"})
    assert %{"id" => "j2", "title" => "Frontend Dev", "description" => "Build UIs", "status" => "open"} = json_response(conn, 200)
  end

  test "PATCH /api/jobs/:id/status updates job status", %{conn: conn} do
    job = Job.new("j3", "QA", "Test stuff")
    :ok = JobRepo.put(job)
    conn = patch(conn, "/api/jobs/j3/status", %{status: "closed"})
    assert %{"id" => "j3", "status" => "closed"} = Map.take(json_response(conn, 200), ["id", "status"])
  end
end
