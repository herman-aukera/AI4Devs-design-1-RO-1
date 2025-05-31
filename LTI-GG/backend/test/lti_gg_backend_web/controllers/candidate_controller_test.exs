defmodule LtiGGBackendWeb.CandidateControllerTest do
  use LtiGGBackendWeb.ConnCase, async: true
  alias LtiGgBackend.Infrastructure.CandidateRepo

  setup do
    {:ok, _} = start_supervised(CandidateRepo)
    CandidateRepo.reset()
    :ok
  end

  test "GET /api/candidates returns empty list", %{conn: conn} do
    conn = get(conn, "/api/candidates")
    assert json_response(conn, 200) == []
  end

  test "POST /api/candidates creates a candidate", %{conn: conn} do
    params = %{id: "10", name: "Test User", email: "test@example.com"}
    conn = post(conn, "/api/candidates", params)
    assert %{"id" => "10", "name" => "Test User", "email" => "test@example.com", "status" => "applied"} = json_response(conn, 201)
  end

  test "PATCH /api/candidates/:id/status updates status", %{conn: conn} do
    params = %{id: "11", name: "Status User", email: "status@example.com"}
    post(conn, "/api/candidates", params)
    conn2 = patch(conn, "/api/candidates/11/status", %{id: "11", status: "hired"})
    assert %{"id" => "11", "status" => "hired"} = Map.take(json_response(conn2, 200), ["id", "status"])
  end

  test "PATCH /api/candidates/:id/status returns 404 for missing candidate", %{conn: conn} do
    conn = patch(conn, "/api/candidates/999/status", %{id: "999", status: "hired"})
    assert response(conn, 404) == "Not found"
  end

  test "PATCH /api/candidates/:id/status returns 400 for invalid status", %{conn: conn} do
    params = %{id: "12", name: "Invalid Status", email: "invalid@example.com"}
    post(conn, "/api/candidates", params)
    conn2 = patch(conn, "/api/candidates/12/status", %{id: "12", status: "notastatus"})
    assert response(conn2, 400) == "Invalid status"
  end
end
