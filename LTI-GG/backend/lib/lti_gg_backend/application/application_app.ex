defmodule LtiGgBackend.Application.ApplicationApp do
  @moduledoc """
  Application layer for Job Application use cases.
  Orchestrates domain logic and coordinates with infrastructure.
  Implements TDD and Clean Architecture principles.
  """
  alias LtiGgBackend.Domain.Application

  @type app_id :: Application.id()
  @type candidate_id :: Application.candidate_id()
  @type job_id :: Application.job_id()
  @type app_status :: Application.status()
  @type app :: Application.t()

  @doc """
  Create a new job application (use case).
  """
  @spec create_application(app_id, candidate_id, job_id) :: app
  def create_application(id, candidate_id, job_id) do
    Application.new(id, candidate_id, job_id)
  end

  @doc """
  Change the status of a job application (use case).
  """
  @spec change_application_status(app, app_status) :: app
  def change_application_status(app, status) do
    Application.change_status(app, status)
  end
end
