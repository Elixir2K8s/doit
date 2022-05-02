import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :pbkdf2_elixir, :rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :doit, Doit.Repo,
  url: System.get_env("DATABASE_URL"),
  #username: System.get_env("PGUSER"),
  #password: System.get_env("PGPASSWORD"),
  #database: System.get_env("PGDATABASE"),
  #hostname: System.get_env("PGHOST"),
  #port:     System.get_env("PGPORT"),
  #username: "postgres",
  #password: "postgres",
  #hostname: "localhost",
  #database: "doit_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :doit, DoitWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "q1+JyWdXVJmf+sMkNNq4x2oTEJp98o60V6bJyE62DqvOCVpo36I4dzn+yrjGkk6V",
  server: false

# In test we don't send emails.
config :doit, Doit.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
