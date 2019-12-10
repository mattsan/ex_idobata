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

  alias ExIdobata.API.{AccessToken, Query, Room}
  import ExIdobata.API.Query, only: [is_format: 1]

  @type access_token :: String.t() | AccessToken.t()
  @type room :: String.t() | Room.t()

  @doc """
  Post a message to the room.

  - `access_token` - An access token got by `ExIdobata.API.AccessToken.get/2` or its token string
  - `room` - One of room got by function `ExIdobata.API.Room.get/1` or its room id
  - `message` - A message to be post to the room
  - `format` - A format of the message. `:plain` (default), `:markdown` or `:html`
  """
  @doc since: "0.2.0"
  @spec post(access_token(), room(), binary(), Query.format()) :: any()
  def post(access_token, room, message, format \\ :plain) when is_format(format) do
    access_token =
      case access_token do
        %AccessToken{access_token: access_token} -> access_token
        access_token when is_binary(access_token) -> access_token
      end

    room_id =
      case room do
        %Room{id: id} -> id
        room_id when is_binary(room_id) -> room_id
      end

    format_string =
      case format do
        :plain -> "PLAIN"
        :markdown -> "MARKDOWN"
        :html -> "HTML"
      end

    case Query.request(access_token, Query.post(), %{
           source: message,
           room_id: room_id,
           format: format_string
         }) do
      %{"data" => data} ->
        data

      {:error, _} = error ->
        error
    end
  rescue
    error -> {:error, error}
  end
end
