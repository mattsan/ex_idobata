defmodule ExIdobata.API do
  @moduledoc """
  GraphQL API module.

  see [idobata public API](https://idobata.io/ja/api)

  To get an access token, request bellow.

  ```sh
  curl https://idobata.io/oauth/token \\
     -H "Content-type: application/json" \\
     -d '{"grant_type":"password", "username":"EMAIL", "password":"PASSWORD" }'
  ```
  """
  @moduledoc since: "0.2.0"

  alias ExIdobata.API.Query
  import ExIdobata.API.Query, only: [is_format: 1]

  @spec viewer(binary()) :: map()
  @doc """
  Gets the viewer name.

  It returns like bellow.

  ```elixir
  %{name: "a_user"}
  ```
  """
  def viewer(access_token) when is_binary(access_token) do
    case Query.request(access_token, Query.viewer()) do
      %{"data" => data} ->
        %{
          name: data["viewer"]["name"]
        }

      {:error, _} = error ->
        error
    end
  end

  @spec rooms(binary()) :: [map()]
  @doc """
  Gets list of romms.

  It returns like bellow.

  ```elixir
  [
    %{id: "aaaaaaa", name: "room1", organization: "foo"},
    %{id: "bbbbbbb", name: "room2", organization: "foo"},
    %{id: "ccccccc", name: "room3", organization: "bar"}
  ]
  ```
  """
  def rooms(access_token) when is_binary(access_token) do
    case Query.request(access_token, Query.rooms()) do
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
  @doc """
  Post a message to the room.

  - `room_id` - One of room id got by function `rooms/1`
  - `message` - A message to be post to the room
  - `format` - A format of the message. `:plain` (default), `:markdown` or `:html`
  """
  def post(access_token, room_id, message, format \\ :plain)
      when is_binary(access_token) and is_binary(room_id) and is_format(format) do
    format_string =
      case format do
        :plain -> "PLAIN"
        :markdown -> "MARKDOWN"
        :html -> "HTML"
      end

    case Query.request(access_token, Query.post(room_id, format_string), %{source: message}) do
      %{"data" => data} ->
        data

      {:error, _} = error ->
        error
    end
  rescue
    error -> {:error, error}
  end
end
