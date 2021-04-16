defmodule TrollkUiWeb.MapLive do
  use TrollkUiWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    routes = Trollk.Routes.Api.get_routes()
    # {:ok, _} = TrollkUi.Trollk.SocketClient.start_link(live_pid: self(), topic: @topic)
    {:ok, assign(socket, :routes, routes)}
  end

  def render(assigns) do
    Phoenix.View.render(TrollkUiWeb.MapView, "map_live.html", assigns)
  end

  def handle_event("subscribe", %{"route-topic" => route_topic}, socket) do
    Logger.info("Subscribe to route #{route_topic}")

    case TrollkUi.Trollk.SocketClient.start_link(live_pid: self(), topic: route_topic) do
      {:ok, _} ->
        Logger.debug("Subscribe succesfully")

      ex ->
        Logger.warn("error received on subscribe #{inspect(ex)}")
    end

    {:noreply, socket}
  end

  def handle_info(event, socket) do
    {:noreply, push_event(socket, "new_coordinates", %{tevent: event})}
  end
end
