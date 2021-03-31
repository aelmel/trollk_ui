# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :trollk_ui, TrollkUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0fTIH66YlvX0Qw2MBmy1AFiwW32NX0FdfnSydIwT7gGOjTv7QXCO60aGaniRc8hP",
  render_errors: [view: TrollkUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TrollkUi.PubSub,
  live_view: [signing_salt: "cMzlVT9H"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
