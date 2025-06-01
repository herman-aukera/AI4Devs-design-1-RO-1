defmodule LtiGgBackend.Application.ApplicationAppTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Application.ApplicationApp
  alias LtiGgBackend.Domain.Application

  describe "create_application/3" do
    test "creates an application with :submitted status" do
      app = ApplicationApp.create_application("2", "cand2", "job2")
      assert %Application{id: "2", candidate_id: "cand2", job_id: "job2", status: :submitted} = app
    end
  end

  describe "change_application_status/2" do
    test "changes the status of an application" do
      app = ApplicationApp.create_application("2", "cand2", "job2")
      updated = ApplicationApp.change_application_status(app, :reviewed)
      assert updated.status == :reviewed
    end
  end
end
