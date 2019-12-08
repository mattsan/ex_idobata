defmodule ExIdobata.API.AccessToken do
  @moduledoc """
  Access Token module.

  See [idobata public API](https://idobata.io/api).
  """
  @moduledoc since: "0.2.0"

  defstruct [:access_token, :created_at, :token_type]

  @type t :: %__MODULE__{
          access_token: String.t(),
          created_at: DateTime.t(),
          token_type: String.t()
        }

  require EEx

  @url "https://idobata.io/oauth/token"
  @body_template ~S[{"grant_type":"password", "username":"<%= email %>", "password":"<%= password %>"}]
  @headers [{"Content-type", "application/json"}]

  EEx.function_from_string(:defp, :body, @body_template, [:email, :password])

  @doc """
  Gets an access token.
  """
  @doc since: "0.2.0"
  @spec get(String.t(), String.t()) :: t()
  def get(email, password) do
    with {:ok, resp} <- HTTPoison.post(@url, body(email, password), @headers),
         {:ok, data} <- Jason.decode(resp.body),
         do: new(data)
  end

  @spec new(map()) :: t()
  defp new(%{
         "access_token" => access_token,
         "created_at" => created_at,
         "token_type" => token_type
       }) do
    %__MODULE__{
      access_token: access_token,
      created_at: DateTime.from_unix!(created_at),
      token_type: token_type
    }
  end
end
