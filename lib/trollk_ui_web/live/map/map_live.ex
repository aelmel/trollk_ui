defmodule TrollkUiWeb.MapLive do
  use TrollkUiWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(TrollkUiWeb.MapView, "map_live.html", assigns)
  end


end
