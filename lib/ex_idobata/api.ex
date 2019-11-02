defmodule ExIdobata.API do
  @moduledoc """
  GraphQL API module.
  """
  @moduledoc since: "0.2.0"

  @url "https://api.idobata.io/graphql"

  alias ExIdobata.API.Query
  import ExIdobata.API.Query, only: [is_format: 1]

  @spec viewer(binary()) :: map()
  def viewer(access_token) when is_binary(access_token) do
    case query(access_token, Query.viewer()) do
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
    case query(access_token, Query.rooms()) do
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

  @spec post(binary(), binary(), binary(), Query.format()) :: any()
  def post(access_token, room_id, message, format \\ :plain)
      when is_binary(access_token) and is_binary(room_id) and is_format(format) do
    format_string =
      case format do
        :plain -> "PLANE"
        :markdown -> "MARKDOWN"
        :html -> "HTML"
      end

    case query(access_token, Query.post(room_id, format_string), %{source: message}) do
      %{"data" => data} ->
        data

      {:error, _} = error ->
        error
    end
  rescue
    error -> {:error, error}
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
