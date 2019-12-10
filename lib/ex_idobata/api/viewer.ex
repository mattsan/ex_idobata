defmodule ExIdobata.API.Viewer do
  @moduledoc """
  A module of viewer of idobata.io.

  See [idobata public API](https://idobata.io/api).
  """
  @moduledoc since: "0.2.0"

  defstruct [:name]

  alias ExIdobata.API.{AccessToken, Query}

  @type t :: %__MODULE__{
          name: String.t()
        }
  @type access_token :: String.t() | AccessToken.t()

  @doc """
  Gets the viewer name.

  It returns like bellow.

  ```elixir
  %ExIdobata.API.Viewer{name: "a_user"}
  ```

  - `access_token` - An access token got by `ExIdobata.API.AccessToken.get/2` or its token string
  """
  @doc since: "0.2.0"
  @spec get(access_token()) :: map()
  def get(access_token) do
    access_token =
      case access_token do
        %AccessToken{access_token: access_token} -> access_token
        access_token when is_binary(access_token) -> access_token
      end

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
