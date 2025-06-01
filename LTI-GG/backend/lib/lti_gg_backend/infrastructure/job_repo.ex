defmodule LtiGgBackend.Infrastructure.JobRepo do
  @moduledoc """
  Infrastructure adapter for in-memory persistence of jobs.
  Uses Elixir Agent for fast, testable storage.
  Follows Clean Architecture: no domain logic here.
  """
  use Agent
  alias LtiGgBackend.Domain.Job

  @type job :: Job.t()
  @type id :: Job.id()

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Store a job.
  """
  @spec put(job) :: :ok
  def put(%Job{id: id} = job) do
    Agent.update(__MODULE__, &Map.put(&1, id, job))
  end

  @doc """
  Get a job by id.
  """
  @spec get(id) :: job | nil
  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  List all jobs.
  """
  @spec all() :: [job]
  def all do
    Agent.get(__MODULE__, &Map.values(&1))
  end

  @doc """
  Reset the in-memory store (for tests or make reset-db).
  """
  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end
end
