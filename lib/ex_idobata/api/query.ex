defmodule ExIdobata.API.Query do
  @moduledoc """
  Define queries for GraphQL API of idobata.io.
  """
  @moduledoc since: "0.2.0"

  @port 443
  @scheme "https"
  @host "api.idobata.io"
  @path "/graphql"
  @url %URI{port: @port, scheme: @scheme, host: @host, path: @path} |> URI.to_string()
  @http_client Application.get_env(:ex_idobata, :http_client, HTTPoison)

  @viewer_query "query { viewer { name } }"
  @rooms_query "query { viewer { rooms { edges { node { id name organization { slug } } } } } }"
  @post_query """
  mutation($source: String!, $room_id: ID!, $format: MessageFormat!) {
    createMessage(input: {
      roomId: $room_id,
      source: $source,
      format: $format
    }) {
      clientMutationId
    }
  }
  """

  @type format :: :plain | :markdown | :html

  @doc """
  Determines if `format` is `t:format/0`.

  Allowed in guard clauses.
  """
  @doc since: "0.2.0"
  defguard is_format(format) when format in [:plain, :markdown, :html]

  require EEx

  @doc false
  @spec viewer :: binary()
  EEx.function_from_string(:def, :viewer, @viewer_query)

  @doc false
  @spec rooms :: binary()
  EEx.function_from_string(:def, :rooms, @rooms_query)

  @doc false
  @spec post :: binary()
  EEx.function_from_string(:def, :post, @post_query)

  @doc false
  @spec request(binary(), binary(), map()) :: any()
  def request(access_token, query_string, vars \\ %{}) do
    {:ok, json} = Jason.encode(%{query: query_string, variables: vars})

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }

    with {:ok, %{status_code: 200} = resp} <- @http_client.post(@url, json, headers),
         {:ok, result} <- Jason.decode(resp.body),
         do: result
  end
end
