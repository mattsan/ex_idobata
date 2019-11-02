defmodule ExIdobata.API do
  @moduledoc """
  GraphQL API module.
  """
  @moduledoc since: "0.2.0"

  require EEx

  @url "https://api.idobata.io/graphql"

  @viewer_query "query { viewer { name } }"
  @rooms_query "query { viewer { rooms { edges { node { id name organization { slug } } } } } }"
  @post_query """
  mutation ($source: String!) {
    createMessage(input: {
      roomId: "<%= room_id %>",
      source: $source,
      format: <%= format %>
    }) {
      clientMutationId
    }
  }
  """

  @type format :: :plain | :markdown | :html

  defguardp is_format(format) when format in [nil, :plain, :markdown, :html]

  EEx.function_from_string(:defp, :post_query, @post_query, [:room_id, :format])

  @spec viewer(binary()) :: map()
  def viewer(access_token) when is_binary(access_token) do
    case query(access_token, @viewer_query) do
      %{"data" => data} ->
        %{
          name: data["viewer"]["name"]
        }

      {:error, _} = error ->
        error
    end
  end

  @spec rooms(binary()) :: [map()]
  def rooms(access_token) when is_binary(access_token) do
    case query(access_token, @rooms_query) do
      %{"data" => data} ->
        data["viewer"]["rooms"]["edges"]
        |> Enum.map(fn %{"node" => node} ->
          %{"id" => id, "name" => name, "organization" => organization} = node
          %{"slug" => slug} = organization

          %{
            id: id,
            name: name,
            organization: slug
          }
        end)

      {:error, _} = error ->
        error
    end
  end

  @spec post(binary(), binary(), binary(), format()) :: map()
  def post(access_token, room_id, message, format \\ :plain)
      when is_binary(access_token) and is_binary(room_id) and is_format(format) do
    format_string =
      case format do
        nil -> "PLAIN"
        :plain -> "PLANE"
        :markdown -> "MARKDOWN"
        :html -> "HTML"
      end

    case query(access_token, post_query(room_id, format_string), %{source: message}) do
      %{"data" => data} ->
        data

      {:error, _} = error ->
        error
    end
  end

  defp query(access_token, query_string, vars \\ %{}) do
    {:ok, json} = Jason.encode(%{query: query_string, variables: vars})

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }

    with {:ok, %{status_code: 200} = resp} <- HTTPoison.post(@url, json, headers),
         {:ok, result} <- Jason.decode(resp.body),
         do: result
  end
end
