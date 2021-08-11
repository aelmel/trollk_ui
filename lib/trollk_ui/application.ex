defmodule TrollkUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, args) do
    children = [
      # Start the Telemetry supervisor
      TrollkUiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TrollkUi.PubSub},
      # Start the Endpoint (http/https)
      TrollkUiWeb.Endpoint
      # Start a worker by calling: TrollkUi.Worker.start_link(arg)
      # {TrollkUi.Worker, arg}
    ]

    children =
      case args do
        [env: :test] ->
          children ++
            [{Plug.Cowboy, schema: :http, plug: Trollk.MockServer, options: [port: 8081]}]

        _ ->
          children
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrollkUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TrollkUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
