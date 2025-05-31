defmodule LtiGgBackend.Domain.Job do
  @moduledoc """
  Domain entity representing a Job in the LTI ATS system.
  """
  @type id :: String.t()
  @type title :: String.t()
  @type description :: String.t()
  @type status :: :open | :closed
  @type t :: %__MODULE__{
          id: id(),
          title: title(),
          description: description(),
          status: status()
        }
  defstruct [:id, :title, :description, :status]

  @spec new(id(), title(), description()) :: t()
  def new(id, title, description) do
    %__MODULE__{id: id, title: title, description: description, status: :open}
  end

  @spec close(t()) :: t()
  def close(%__MODULE__{} = job), do: %__MODULE__{job | status: :closed}
end
