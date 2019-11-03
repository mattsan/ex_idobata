defmodule ExIdobata.APITest do
  use ExUnit.Case
  doctest ExIdobata.API

  import ExUnit.CaptureLog
  alias ExIdobata.API

  setup_all do
    {:ok, _} = start_supervised(ExIdobata.Mock.HTTPClient)
    :ok
  end

  setup context do
    response = context[:response]

    if response do
      ExIdobata.Mock.HTTPClient.set_response(response)
    end

    :ok
  end

  @tag response: {:ok, %{status_code: 200, body: ~S({"data":{"viewer":{"name":"foobar"}}})}}
  test "viewer" do
    expected = """
    url: 'https://api.idobata.io/graphql'
    body: '"{\\\"query\\\":\\\"query { viewer { name } }\\\",\\\"variables\\\":{}}"'
    headers: '%{"Authorization" => "Bearer access-token", "Content-Type" => "application/json"}'
    options: '[]'
    """

    actual =
      capture_log(fn ->
        assert API.viewer("access-token") == %{name: "foobar"}
      end)

    assert actual =~ expected
  end

  @tag response:
         {:ok,
          %{
            status_code: 200,
            body: """
            {
              "data": {
                "viewer": {
                  "rooms": {
                    "edges": [
                      {"node": {"id": "abc123", "name": "foo", "organization": {"slug": "hoge"}}},
                      {"node": {"id": "def456", "name": "bar", "organization": {"slug": "fuga"}}}
                    ]
                  }
                }
              }
            }
            """
          }}
  test "rooms" do
    expected = """
    url: 'https://api.idobata.io/graphql'
    body: '"{\\\"query\\\":\\\"query { viewer { rooms { edges { node { id name organization { slug } } } } } }\\\",\\\"variables\\\":{}}"'
    headers: '%{"Authorization" => "Bearer access-token", "Content-Type" => "application/json"}'
    options: '[]'
    """

    actual =
      capture_log(fn ->
        assert API.rooms("access-token") == [
                 %{id: "abc123", name: "foo", organization: "hoge"},
                 %{id: "def456", name: "bar", organization: "fuga"}
               ]
      end)

    assert actual =~ expected
  end
end
