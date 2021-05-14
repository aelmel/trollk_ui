defmodule TrollkUiWeb.MapView do
  use TrollkUiWeb, :view

  def get_route_button(%{"number" => number, "name" => name, "color" => color} = params) do
    IO.inspect(params)
    assigns = %{number: number, name: name, topic: "route:#{number}", color: color}

    ~L"""
    <button class="css-framework-class" phx-click="subscribe" phx-value-route-topic="<%= @topic %>" phx-value-route-color="<%= @color %>">
        <%= @number %>
    </button>
    """
  end
end
