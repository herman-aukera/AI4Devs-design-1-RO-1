defmodule LtiGgBackend.Domain.JobTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Domain.Job

  describe "Job.new/3" do
    test "creates a job with :open status" do
      job = Job.new("1", "Dev", "Build stuff")
      assert job.id == "1"
      assert job.title == "Dev"
      assert job.description == "Build stuff"
      assert job.status == :open
    end
  end

  describe "Job.close/1" do
    test "closes a job" do
      job = Job.new("1", "Dev", "Build stuff")
      closed = Job.close(job)
      assert closed.status == :closed
    end
  end
end
