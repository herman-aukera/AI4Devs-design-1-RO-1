defmodule LtiGgBackend.Application.JobAppTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Application.JobApp
  alias LtiGgBackend.Domain.Job

  describe "create_job/3" do
    test "creates a job with :open status" do
      job = JobApp.create_job("2", "Frontend Dev", "Build UIs")
      assert %Job{id: "2", title: "Frontend Dev", description: "Build UIs", status: :open} = job
    end
  end

  describe "change_job_status/2" do
    test "changes the status of a job" do
      job = JobApp.create_job("2", "Frontend Dev", "Build UIs")
      updated = JobApp.change_job_status(job, :closed)
      assert updated.status == :closed
    end
  end
end
