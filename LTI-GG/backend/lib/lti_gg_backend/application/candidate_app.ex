defmodule LtiGgBackend.Application.CandidateApp do
  @moduledoc """
  Application layer for Candidate use cases.
  Orchestrates domain logic and coordinates with infrastructure.
  Implements TDD and Clean Architecture principles.
  """
  alias LtiGgBackend.Domain.Candidate

  @type candidate_id :: Candidate.id()
  @type candidate_name :: Candidate.name()
  @type candidate_email :: Candidate.email()
  @type candidate_status :: Candidate.status()
  @type candidate :: Candidate.t()

  @doc """
  Create a new candidate (use case).
  """
  @spec create_candidate(candidate_id, candidate_name, candidate_email) :: candidate
  def create_candidate(id, name, email) do
    Candidate.new(id, name, email)
  end

  @doc """
  Change the status of a candidate (use case).
  """
  @spec change_candidate_status(candidate, candidate_status) :: candidate
  def change_candidate_status(candidate, status) do
    Candidate.change_status(candidate, status)
  end
end
