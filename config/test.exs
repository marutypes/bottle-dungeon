use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bottle_dungeon, BottleDungeonWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bottle_dungeon, BottleDungeon.Repo,
  username: "postgres",
  password: "postgres",
  database: "bottle_dungeon_ssr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Intentionally speed up hashing in tests
config :pbkdf2_elixir, :rounds, 1
