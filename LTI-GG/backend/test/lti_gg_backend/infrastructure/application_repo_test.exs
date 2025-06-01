defmodule LtiGgBackend.Infrastructure.ApplicationRepoTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Infrastructure.ApplicationRepo
  alias LtiGgBackend.Domain.Application

  setup do
    {:ok, _} = start_supervised(ApplicationRepo)
    ApplicationRepo.reset()
    :ok
  end

  test "put/1 and get/1 store and retrieve an application" do
    app = Application.new("a1", "cand1", "job1")
    assert :ok == ApplicationRepo.put(app)
    assert ApplicationRepo.get("a1") == app
  end

  test "all/0 lists all applications" do
    a1 = Application.new("a2", "cand2", "job2")
    a2 = Application.new("a3", "cand3", "job3")
    ApplicationRepo.put(a1)
    ApplicationRepo.put(a2)
    all = ApplicationRepo.all()
    assert Enum.member?(all, a1)
    assert Enum.member?(all, a2)
  end

  test "reset/0 clears the store" do
    a = Application.new("a4", "cand4", "job4")
    ApplicationRepo.put(a)
    ApplicationRepo.reset()
    assert ApplicationRepo.all() == []
  end
end
