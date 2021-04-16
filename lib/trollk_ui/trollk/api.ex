defmodule Trollk.Routes.Api do
  @moduledoc """
  Api to call trollk to get route details
  """
  require Logger

  def get_routes() do
    [
      %{"number" => "8", "name" => "bd. Traian - Parcul 'La Izvor'"},
      %{"number" => "10", "name" => "bd. Moscova - str. Miorița"}
    ]
  end

  def get_details("route:" <> route_number) do
    call("http://localhost:4040/api/details/route/#{route_number}")
  end

  defp call(url, headers \\ []) do
    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, details} ->
            details

          err ->
            Logger.warn("cannot parse json #{inspect(err)}")
        end

      {:ok, %{status_code: status_code}} ->
        Logger.warn("Error code from server #{status_code}")
        {:error, "Cannot fetch details"}

      ex ->
        Logger.warn("Internal error #{inspect(ex)}")
        {:error, "Cannot fetch details"}
    end
  end
end
