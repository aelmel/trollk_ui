import Config

config :trollk_ui,
  trollk_base_host: System.get_env("TROLLK_BASE_HOST") || "localhost:4040"
