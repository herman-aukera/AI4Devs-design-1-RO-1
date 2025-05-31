defmodule LtiGgBackend.Application.CandidateAppTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Application.CandidateApp
  alias LtiGgBackend.Domain.Candidate

  describe "create_candidate/3" do
    test "creates a candidate with :applied status" do
      candidate = CandidateApp.create_candidate("2", "Bob", "bob@example.com")
      assert %Candidate{id: "2", name: "Bob", email: "bob@example.com", status: :applied} = candidate
    end
  end

  describe "change_candidate_status/2" do
    test "changes the status of a candidate" do
      candidate = CandidateApp.create_candidate("2", "Bob", "bob@example.com")
      updated = CandidateApp.change_candidate_status(candidate, :hired)
      assert updated.status == :hired
    end
  end
end
