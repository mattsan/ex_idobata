defmodule ExIdobata.API.Room do
  @moduledoc """
  A module of room of idobata.io.

  See [idobata public API](https://idobata.io/api).
  """
  @moduledoc since: "0.2.0"

  defstruct [:id, :name, :organization]

  alias ExIdobata.API.Query

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          organization: String.t()
        }

  @doc """
  Gets list of rooms.

  It returns like bellow.

  ```elixir
  [
    %ExIdobata.API.Room{id: "aaaaaaa", name: "room1", organization: "foo"},
    %ExIdobata.API.Room{id: "bbbbbbb", name: "room2", organization: "foo"},
    %ExIdobata.API.Room{id: "ccccccc", name: "room3", organization: "bar"}
  ]
  ```
  """
  @doc since: "0.2.0"
  @spec get(binary()) :: [map()]
  def get(access_token) when is_binary(access_token) do
    case Query.request(access_token, Query.rooms()) do
      %{"data" => data} ->
        data["viewer"]["rooms"]["edges"]
        |> Enum.map(fn %{"node" => node} ->
          %{"id" => id, "name" => name, "organization" => organization} = node
          %{"slug" => slug} = organization

          %__MODULE__{
            id: id,
            name: name,
            organization: slug
          }
        end)

      {:error, _} = error ->
        error
    end
  end
end
