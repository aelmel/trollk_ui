defmodule Trollk.Routes.Api do
  @moduledoc """
  Api to call trollk to get route details
  """
  require Logger

  def get_routes() do
    host = Application.get_env(:trollk_ui, :trollk_base_host)
    call("http://#{host}/api/details/routes")
  end

  def get_details("route:" <> route_number) do
    host = Application.get_env(:trollk_ui, :trollk_base_host)
    "http://#{host}/api/details/route/#{route_number}"
    |> call()
    |> Map.get("segment", %{})
    |> Jason.encode()
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
