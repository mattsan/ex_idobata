defmodule ExIdobata.Mock.HTTPClient do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def post(url, body, headers, options \\ []) do
    GenServer.call(__MODULE__, {:post, url, body, headers, options})
  end

  def set_response(response) do
    GenServer.call(__MODULE__, {:set_response, response})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:post, url, body, headers, options}, _from, state) do
    require Logger

    Logger.debug("""
    url: '#{url}'
    body: '#{inspect(body)}'
    headers: '#{inspect(headers)}'
    options: '#{inspect(options)}'
    """)

    response = state[:response]

    {:reply, response, state}
  end

  def handle_call({:set_response, response}, _from, state) do
    {:reply, :ok, Map.put(state, :response, response)}
  end
end
