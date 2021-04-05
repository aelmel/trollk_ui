defmodule TrollkUiWeb.MapLive do
  use TrollkUiWeb, :live_view
  @topic "route:8"

  def mount(_params, _session, socket) do
    {:ok, _} = TrollkUi.Trollk.SocketClient.start_link([live_pid: self(), topic: @topic])
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(TrollkUiWeb.MapView, "map_live.html", assigns)
  end

  def handle_info(event, socket) do
    {:noreply, push_event(socket, "new_coordinates", %{tevent: event})}
  end


end