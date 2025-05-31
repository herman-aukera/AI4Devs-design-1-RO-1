defmodule LtiGgBackend.Infrastructure.CandidateRepo do
  @moduledoc """
  Infrastructure adapter for Candidate persistence using Agent (in-memory store).
  Follows Clean Architecture: no domain logic, only persistence concerns.
  """
  use Agent
  alias LtiGgBackend.Domain.Candidate

  @type candidate :: Candidate.t()
  @type id :: Candidate.id()

  # Starts the Agent (should be called in application supervision tree)
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Store a candidate in the repository.
  """
  @spec put(candidate) :: :ok
  def put(%Candidate{id: id} = candidate) do
    Agent.update(__MODULE__, &Map.put(&1, id, candidate))
  end

  @doc """
  Get a candidate by id.
  """
  @spec get(id) :: candidate | nil
  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  List all candidates.
  """
  @spec all() :: [candidate]
  def all do
    Agent.get(__MODULE__, &Map.values(&1))
  end

  @doc """
  Reset the repository (for tests or reset-db).
  """
  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end
end
