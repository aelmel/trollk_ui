defmodule TrollkUiWeb.MapView do
  use TrollkUiWeb, :view

  def get_route_button(%{"number" => number, "name" => name}) do
    assigns = %{number: number, name: name, topic: "route:#{number}"}

    ~L"""
    <button class="css-framework-class" phx-click="subscribe" phx-value-route-topic="<%= @topic %>">
        <%= @number %>
    </button>
    """
  end
end
