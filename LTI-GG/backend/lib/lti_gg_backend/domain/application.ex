defmodule LtiGgBackend.Domain.Application do
  @moduledoc """
  Domain entity representing a Job Application in the LTI ATS system.
  """
  @type id :: String.t()
  @type candidate_id :: String.t()
  @type job_id :: String.t()
  @type status :: :submitted | :reviewed | :rejected | :accepted
  @type t :: %__MODULE__{
          id: id(),
          candidate_id: candidate_id(),
          job_id: job_id(),
          status: status()
        }
  defstruct [:id, :candidate_id, :job_id, :status]

  @spec new(id(), candidate_id(), job_id()) :: t()
  def new(id, candidate_id, job_id) do
    %__MODULE__{
      id: id,
      candidate_id: candidate_id,
      job_id: job_id,
      status: :submitted
    }
  end

  @doc """
  Change the status of an application.
  """
  @spec change_status(t(), status()) :: t()
  def change_status(%__MODULE__{} = app, status), do: %__MODULE__{app | status: status}
end
