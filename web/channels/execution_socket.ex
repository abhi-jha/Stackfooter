defmodule Stackfooter.ExecutionSocket do
  alias Phoenix.PubSub

  def init(req, opts) do
    {:cowboy_websocket, req, opts}
  end

  def init(_, req, opts) do
    {:upgrade, :protocol, :cowboy_websocket, req, opts}
  end

  def websocket_init(_type, req, _opts) do
    {bindings, _} = :cowboy_req.bindings(req)
    params = Enum.reduce(bindings, %{}, fn ({key, val}, acc) ->
      Map.put(acc, Atom.to_string(key), String.upcase(val))
    end)

    case params do
      %{"trading_account" => account, "venue" => venue, "stock" => stock} ->
        PubSub.subscribe Stackfooter.PubSub, self, "executions:#{String.upcase(account)}-#{String.upcase(venue)}-#{String.upcase(stock)}"
      %{"trading_account" => account, "venue" => venue} ->
        PubSub.subscribe Stackfooter.PubSub, self, "executions:#{String.upcase(account)}-#{String.upcase(venue)}"
    end

    {:ok, req, %{}}
  end

  def websocket_handle(_data, req, state) do
    {:ok, req, state}
  end

  def websocket_info({:execution, execution} = _info, req, state) do
    resp =  case Poison.encode(execution) do
              {:ok, encoded} ->
                encoded
              _ ->
                "{\"ok\":false,\"error\":\"An error occurred\"}"
            end

    {:reply, {:text, resp}, req, state}
  end

  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
