defmodule LtiGgBackend.Infrastructure.CandidateRepoTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Infrastructure.CandidateRepo
  alias LtiGgBackend.Domain.Candidate

  setup do
    case Agent.start_link(fn -> %{} end, name: LtiGgBackend.Infrastructure.CandidateRepo) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _pid}} -> :ok
    end
    CandidateRepo.reset()
    :ok
  end

  test "put/1 and get/1 store and retrieve a candidate" do
    candidate = %Candidate{id: "3", name: "Carol", email: "carol@example.com", status: :applied}
    assert :ok == CandidateRepo.put(candidate)
    assert CandidateRepo.get("3") == candidate
  end

  test "all/0 lists all candidates" do
    c1 = %Candidate{id: "4", name: "Dan", email: "dan@example.com", status: :applied}
    c2 = %Candidate{id: "5", name: "Eve", email: "eve@example.com", status: :applied}
    CandidateRepo.put(c1)
    CandidateRepo.put(c2)
    all = CandidateRepo.all()
    assert Enum.member?(all, c1)
    assert Enum.member?(all, c2)
  end

  test "reset/0 clears the repository" do
    c = %Candidate{id: "6", name: "Frank", email: "frank@example.com", status: :applied}
    CandidateRepo.put(c)
    assert CandidateRepo.get("6") == c
    CandidateRepo.reset()
    assert CandidateRepo.get("6") == nil
  end
end
