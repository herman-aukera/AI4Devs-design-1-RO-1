defmodule LtiGGBackendWeb.ApplicationControllerTest do
  use LtiGGBackendWeb.ConnCase, async: true
  alias LtiGgBackend.Infrastructure.ApplicationRepo
  alias LtiGgBackend.Domain.Application

  setup do
    case Agent.start_link(fn -> %{} end, name: LtiGgBackend.Infrastructure.ApplicationRepo) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
    ApplicationRepo.reset()
    :ok
  end

  test "GET /api/applications returns all applications", %{conn: conn} do
    app = Application.new("a1", "cand1", "job1")
    :ok = ApplicationRepo.put(app)
    conn = get(conn, "/api/applications")
    assert json_response(conn, 200) == [%{"id" => "a1", "candidate_id" => "cand1", "job_id" => "job1", "status" => "submitted"}]
  end

  test "POST /api/applications creates an application", %{conn: conn} do
    conn = post(conn, "/api/applications", %{id: "a2", candidate_id: "cand2", job_id: "job2"})
    assert %{"id" => "a2", "candidate_id" => "cand2", "job_id" => "job2", "status" => "submitted"} = json_response(conn, 200)
  end

  test "PATCH /api/applications/:id/status updates application status", %{conn: conn} do
    app = Application.new("a3", "cand3", "job3")
    :ok = ApplicationRepo.put(app)
    conn = patch(conn, "/api/applications/a3/status", %{status: "reviewed"})
    assert %{"id" => "a3", "status" => "reviewed"} = Map.take(json_response(conn, 200), ["id", "status"])
  end
end
