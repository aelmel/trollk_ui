import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :trollk_ui, TrollkUiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :trollk_ui,
  trollk_base_host: "localhost:4040"
