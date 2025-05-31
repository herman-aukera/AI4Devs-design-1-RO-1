defmodule LtiGgBackend.Domain.ApplicationTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Domain.Application

  describe "Application.new/3" do
    test "creates an application with :submitted status" do
      app = Application.new("1", "cand1", "job1")
      assert app.id == "1"
      assert app.candidate_id == "cand1"
      assert app.job_id == "job1"
      assert app.status == :submitted
    end
  end

  describe "Application.change_status/2" do
    test "changes the status of an application" do
      app = Application.new("1", "cand1", "job1")
      reviewed = Application.change_status(app, :reviewed)
      assert reviewed.status == :reviewed
    end
  end
end
