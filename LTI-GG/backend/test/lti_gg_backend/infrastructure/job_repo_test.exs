defmodule LtiGgBackend.Infrastructure.JobRepoTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Infrastructure.JobRepo
  alias LtiGgBackend.Domain.Job

  setup do
    {:ok, _} = start_supervised(JobRepo)
    JobRepo.reset()
    :ok
  end

  test "put/1 and get/1 store and retrieve a job" do
    job = Job.new("j1", "Backend Dev", "Build APIs")
    assert :ok == JobRepo.put(job)
    assert JobRepo.get("j1") == job
  end

  test "all/0 lists all jobs" do
    j1 = Job.new("j2", "Frontend Dev", "Build UIs")
    j2 = Job.new("j3", "QA", "Test stuff")
    JobRepo.put(j1)
    JobRepo.put(j2)
    all = JobRepo.all()
    assert Enum.member?(all, j1)
    assert Enum.member?(all, j2)
  end

  test "reset/0 clears the store" do
    j = Job.new("j4", "DevOps", "Deploy things")
    JobRepo.put(j)
    JobRepo.reset()
    assert JobRepo.all() == []
  end
end
