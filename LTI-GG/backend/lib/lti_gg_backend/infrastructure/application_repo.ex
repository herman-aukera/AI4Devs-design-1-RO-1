defmodule LtiGgBackend.Infrastructure.ApplicationRepo do
  @moduledoc """
  Infrastructure adapter for in-memory persistence of job applications.
  Uses Elixir Agent for fast, testable storage.
  Follows Clean Architecture: no domain logic here.
  """
  use Agent
  alias LtiGgBackend.Domain.Application

  @type app :: Application.t()
  @type id :: Application.id()

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Store an application.
  """
  @spec put(app) :: :ok
  def put(%Application{id: id} = app) do
    Agent.update(__MODULE__, &Map.put(&1, id, app))
  end

  @doc """
  Get an application by id.
  """
  @spec get(id) :: app | nil
  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  @doc """
  List all applications.
  """
  @spec all() :: [app]
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

  @doc """
  Delete an application by id.
  """
  @spec delete(id) :: :ok
  def delete(id) do
    Agent.update(__MODULE__, &Map.delete(&1, id))
  end
end
