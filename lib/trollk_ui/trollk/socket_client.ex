defmodule TrollkUi.Trollk.SocketClient do
  @moduledoc """
  A websocket client to receive routes changes
  """
  require Logger
  alias Phoenix.Channels.GenSocketClient
  @behaviour GenSocketClient

  def start_link(connection_details) do
    # "ws://localhost:4000/socket/websocket"
    GenSocketClient.start_link(
      __MODULE__,
      Phoenix.Channels.GenSocketClient.Transport.WebSocketClient,
      connection_details
    )
  end

  def init(connection_details) do
    url = "ws://localhost:4040/socket/websocket"
    topic = Keyword.get(connection_details, :topic)
    pid = Keyword.get(connection_details, :live_pid)
    color = Keyword.get(connection_details, :color)
    {:connect, url, [], %{first_join: true, ping_ref: 1, topic: topic, live_pid: pid, color: color}}
  end

  def handle_connected(transport, state) do
    topic = Map.get(state, :topic)
    Logger.info("connected ")
    GenSocketClient.join(transport, topic)
    {:ok, state}
  end

  def handle_disconnected(reason, state) do
    Logger.error("disconnected: #{inspect(reason)}")
    Process.send_after(self(), :connect, :timer.seconds(1))
    {:ok, state}
  end

  def handle_joined(topic, _payload, _transport, state) do
    Logger.info("joined the topic #{topic}")
    {:ok, %{state | ping_ref: 1}}
  end

  def handle_join_error(topic, payload, _transport, state) do
    Logger.error("join error on the topic #{topic}: #{inspect(payload)}")
    {:ok, state}
  end

  def handle_channel_closed(topic, payload, _transport, state) do
    Logger.error("disconnected from the topic #{topic}: #{inspect(payload)}")
    Process.send_after(self(), {:join, topic}, :timer.seconds(1))
    {:ok, state}
  end

  def handle_message(topic, event, payload, _transport, %{live_pid: pid} = state) do
    Logger.debug("message on topic #{topic}: #{event} #{inspect(payload)}")

    Kernel.send(pid, Map.put(payload, :color, state.color))
    {:ok, state}
  end

  def handle_reply("ping", _ref, %{"status" => "ok"} = payload, _transport, state) do
    Logger.info("server pong # #{inspect(payload)}")
    {:ok, state}
  end

  def handle_reply(topic, _ref, payload, _transport, state) do
    Logger.info("reply on topic #{topic}: #{inspect(payload)}")
    {:ok, state}
  end

  def handle_info(:connect, _transport, state) do
    Logger.info("connecting")
    {:connect, state}
  end

  def handle_info({:join, topic}, transport, state) do
    Logger.info("joining the topic #{topic}")

    case GenSocketClient.join(transport, topic) do
      {:error, reason} ->
        Logger.error("error joining the topic #{topic}: #{inspect(reason)}")
        Process.send_after(self(), {:join, topic}, :timer.seconds(1))

      {:ok, _ref} ->
        :ok
    end

    {:ok, state}
  end

  def handle_info(:ping_server, transport, state) do
    Logger.info("sending ping ##{state.ping_ref}")
    GenSocketClient.push(transport, "ping", "ping", %{ping_ref: state.ping_ref})
    {:ok, %{state | ping_ref: state.ping_ref + 1}}
  end

  def handle_info(stop, _transport, state) do
    Logger.warn("stopping the socket client")
    {:stop, :normal, state}
  end

  def handle_info(message, _transport, state) do
    Logger.warn("Unhandled message #{inspect(message)}")
    {:ok, state}
  end

  def handle_call(message, _from, _transport, state) do
    Logger.warn("Did not expect to receive call with message: #{inspect(message)}")
    {:reply, {:error, :unexpected_message}, state}
  end

  def terminate(reason, _state) do
    Logger.info("Terminating and cleaning up state. Reason for termination: #{reason}")
  end
end
