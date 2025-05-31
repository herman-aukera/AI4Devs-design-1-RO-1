defmodule LtiGgBackend.Domain.Candidate do
  @moduledoc """
  Domain entity representing a Candidate in the LTI ATS system.
  This module defines the core business rules and types for a candidate.
  Follows Clean Architecture: no dependencies on infrastructure or frameworks.
  """

  @type id :: String.t()
  @type name :: String.t()
  @type email :: String.t()
  @type status :: :applied | :screening | :interview | :offer | :hired | :rejected
  @type t :: %__MODULE__{
          id: id(),
          name: name(),
          email: email(),
          status: status()
        }

  defstruct [
    :id,
    :name,
    :email,
    :status
  ]

  @doc """
  Create a new candidate.
  """
  @spec new(id(), name(), email()) :: t()
  def new(id, name, email) do
    %__MODULE__{
      id: id,
      name: name,
      email: email,
      status: :applied
    }
  end

  @doc """
  Change the status of a candidate.
  """
  @spec change_status(t(), status()) :: t()
  def change_status(%__MODULE__{} = candidate, status) do
    %__MODULE__{candidate | status: status}
  end
end
