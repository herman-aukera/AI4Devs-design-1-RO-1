defmodule LtiGgBackend.Application.JobApp do
  @moduledoc """
  Application layer for Job use cases.
  Orchestrates domain logic and coordinates with infrastructure.
  Implements TDD and Clean Architecture principles.
  """
  alias LtiGgBackend.Domain.Job

  @type job_id :: Job.id()
  @type job_title :: Job.title()
  @type job_description :: Job.description()
  @type job_status :: Job.status()
  @type job :: Job.t()

  @doc """
  Create a new job (use case).
  """
  @spec create_job(job_id, job_title, job_description) :: job
  def create_job(id, title, description) do
    Job.new(id, title, description)
  end

  @doc """
  Change the status of a job (use case).
  """
  @spec change_job_status(job, job_status) :: job
  def change_job_status(job, status) do
    Job.change_status(job, status)
  end
end
