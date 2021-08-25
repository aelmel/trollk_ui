defmodule Trollk.Routes.Api do
  @moduledoc """
  Api to call trollk to get route details
  """
  require Logger

  @base_url Application.get_env(:trollk_ui, :trollk_base_host)

  def get_routes() do
    host =
      case get_call("http://#{@base_url}/api/details/routes") do
        {:error, _} ->
          {:error, "Cannot get routes details"}

        response ->
          response
      end
  end

  def get_details("route:" <> route_number) do
    host = Application.get_env(:trollk_ui, :trollk_base_host)

    case get_call("http://#{@base_url}/api/details/route/#{route_number}") do
      {:error, _} ->
        {:error, "Cannot get details for route #{route_number}"}

      response ->
        response
        |> Map.get("segment", %{})
        |> Jason.encode()
    end
  end

  defp get_call(url, headers \\ []) do
    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, details} ->
            details

          err ->
            Logger.warn("cannot parse json #{inspect(err)}")
            {:error, "Got wrong format"}
        end

      {:ok, %{status_code: status_code}} ->
        Logger.warn("Error code from server #{status_code}")
        {:error, "Cannot fetch details with status_code #{status_code}"}

      ex ->
        Logger.warn("Internal error #{inspect(ex)}")
        {:error, "Cannot fetch details"}
    end
  end
end
