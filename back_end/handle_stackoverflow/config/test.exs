import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :handle_stackoverflow, HandleStackoverflow.Repo,
  username: "nikhil",
  password: "postgres",
  hostname: "localhost",
  database: "handle_stackoverflow_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :handle_stackoverflow, HandleStackoverflowWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JyqW73vcH9qE3WRh9TWJ1eqBy7lB51wuUISPjyU9CcBE9meQKaPoUfptrsi+4Jou",
  server: false

# In test we don't send emails
config :handle_stackoverflow, HandleStackoverflow.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
