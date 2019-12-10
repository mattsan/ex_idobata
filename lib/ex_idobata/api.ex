defmodule ExIdobata.API do
  @moduledoc """
  GraphQL API module.

  See [idobata public API](https://idobata.io/api).

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

  @doc """
  Post a message to the room.

  - `room_id` - One of room id got by function `rooms/1`
  - `message` - A message to be post to the room
  - `format` - A format of the message. `:plain` (default), `:markdown` or `:html`
  """
  @doc since: "0.2.0"
  @spec post(binary(), binary(), binary(), Query.format()) :: any()
  def post(access_token, room_id, message, format \\ :plain)
      when is_binary(access_token) and is_binary(room_id) and is_format(format) do
    format_string =
      case format do
        :plain -> "PLAIN"
        :markdown -> "MARKDOWN"
        :html -> "HTML"
      end

    case Query.request(access_token, Query.post(), %{source: message, room_id: room_id, format: format_string}) do
      %{"data" => data} ->
        data

      {:error, _} = error ->
        error
    end
  rescue
    error -> {:error, error}
  end
end
