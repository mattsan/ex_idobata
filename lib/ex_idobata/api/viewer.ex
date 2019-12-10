defmodule ExIdobata.API.Viewer do
  @moduledoc """
  A module of viewer of idobata.io.

  See [idobata public API](https://idobata.io/api).
  """
  @moduledoc since: "0.2.0"

  defstruct [:name]

  alias ExIdobata.API.Query

  @type t :: %__MODULE__{
          name: String.t()
        }

  @doc """
  Gets the viewer name.

  It returns like bellow.

  ```elixir
  %ExIdobata.API.Viewer{name: "a_user"}
  ```
  """
  @doc since: "0.2.0"
  @spec get(binary()) :: map()
  def get(access_token) when is_binary(access_token) do
    case Query.request(access_token, Query.viewer()) do
      %{"data" => data} ->
        %__MODULE__{
          name: data["viewer"]["name"]
        }

      {:error, _} = error ->
        error
    end
  end
end
