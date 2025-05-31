defmodule LtiGgBackend.Domain.CandidateTest do
  use ExUnit.Case, async: true
  alias LtiGgBackend.Domain.Candidate

  describe "Candidate.new/3" do
    test "creates a candidate with :applied status" do
      candidate = Candidate.new("1", "Alice", "alice@example.com")
      assert candidate.id == "1"
      assert candidate.name == "Alice"
      assert candidate.email == "alice@example.com"
      assert candidate.status == :applied
    end
  end

  describe "Candidate.change_status/2" do
    test "changes the status of a candidate" do
      candidate = Candidate.new("1", "Alice", "alice@example.com")
      updated = Candidate.change_status(candidate, :interview)
      assert updated.status == :interview
    end
  end
end
