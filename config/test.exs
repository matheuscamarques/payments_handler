import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :payments_handler, PaymentsHandlerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1dieGbkFWGCumsWqiB2qi8n+Kov/hTMe1hxrIpO4B5iWS4RWbgzFrQQ86B17i3cB",
  server: false

# In test we don't send emails.
config :payments_handler, PaymentsHandler.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
