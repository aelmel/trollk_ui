defmodule TrollkUiWeb.MapLive do
  use TrollkUiWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    case Trollk.Routes.Api.get_routes() do
      {:error, message} ->
        {:ok, assign(socket, routes: [], routes_error: message)}

      routes ->
        {:ok, assign(socket, :routes, routes)}
    end

    # {:ok, _} = TrollkUi.Trollk.SocketClient.start_link(live_pid: self(), topic: @topic)
  end

  def render(assigns) do
    Phoenix.View.render(TrollkUiWeb.MapView, "map_live.html", assigns)
  end

  def handle_event("subscribe", %{"route-topic" => route_topic, "route-color" => color}, socket) do
    Logger.info("Subscribe to route #{route_topic}")

    {:ok, _} =
      TrollkUi.Trollk.SocketClient.start_link(live_pid: self(), topic: route_topic, color: color)

    case Trollk.Routes.Api.get_details(route_topic) do
      {:ok, segment} ->
        Logger.debug("got segment")

        {:noreply,
         push_event(socket, "route_segment", %{segment: segment, route: route_topic, color: color})}

      _ ->
        {:noreply, socket}
    end

    # case TrollkUi.Trollk.SocketClient.start_link(live_pid: self(), topic: route_topic) do
    #   {:ok, _} ->
    #     Logger.debug("Subscribe succesfully")
    #     case Trollk.Routes.Api.get_details(route_topic) do
    #       {:ok, segment} ->
    #         Logger.debug("got segment")
    #         {:noreply, push_event(socket, "route_segment", %{segment: segment})}
    #       _ ->
    #         {:noreply, socket}
    #     end
    #   ex ->
    #     Logger.warn("error received on subscribe #{inspect(ex)}")
    # end

    # {:noreply, socket}
  end

  def handle_info(event, socket) do
    {:noreply, push_event(socket, "new_coordinates", %{tevent: event})}
  end
end
