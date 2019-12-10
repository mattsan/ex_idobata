defmodule ExIdobata.API.QueryTest do
  use ExUnit.Case
  doctest ExIdobata.API.Query

  alias ExIdobata.API.Query
  import ExUnit.CaptureLog

  setup_all do
    {:ok, _} = start_supervised(ExIdobata.Mock.HTTPClient)
    :ok
  end

  test "request" do
    expected = """
    url: 'https://api.idobata.io/graphql'
    body: '\"{\\\"query\\\":\\\"message\\\",\\\"variables\\\":{}}\"'
    headers: '%{"Authorization" => "Bearer access-token", "Content-Type" => "application/json"}'
    options: '[]'
    """

    assert capture_log(fn ->
             Query.request("access-token", "message", %{})
           end) =~ expected
  end
end
