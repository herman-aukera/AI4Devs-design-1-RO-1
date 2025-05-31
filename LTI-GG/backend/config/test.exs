import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lti_gg_backend, LtiGGBackendWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "dEs2CbYfUdE9M0DJsS9w4q/QNKlCQ3RnWwrKtBGVZtc54ATGPFq7YugTG3ysVNya",
  server: false

# In test we don't send emails
config :lti_gg_backend, LtiGGBackend.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
