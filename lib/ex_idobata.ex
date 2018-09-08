defmodule ExIdobata do
  @moduledoc """
  An [Idobata.io](https://idobata.io/home) client in Elixir.
  """

  defmodule Endpoint do
    defstruct [:url]
  end

  alias ExIdobata.Endpoint

  @type endpoint :: %ExIdobata.Endpoint{}
  @type httpoison_result :: {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()} | {:error, HTTPoison.Error.t()}

  @spec new_hook(String.t()) :: endpoint
  @doc """
  Get hook data of Idobata.io.
  """
  def new_hook(url) do
    %Endpoint{url: url}
  end

  @doc """
  Post a message to Idobata.io.

  ## option

  - `:html` - set `true`, `message` is post as HTML.
  """
  @spec post_message(endpoint, String.t(), Keyword.t()) :: httpoison_result
  def post_message(%Endpoint{url: url}, message, options \\ []) do
    headers = ["Content-Type": "application/x-www-form-urlencoded"]

    body =
      [source: message, format: format(options)]
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> URI.encode_query()

    HTTPoison.post(url, body, headers)
  end

  @doc """
  Post an image to Idobata.io from image file.
  """
  @spec post_image_file(endpoint, String.t()) :: httpoison_result
  def post_image_file(%Endpoint{url: url}, filename) do
    HTTPoison.post(url, muptipart_image(filename))
  end

  defp muptipart_image(filename) do
    {:multipart, [{:file, Path.expand(filename), {"form-data", [{"name", "image"}, {"filename", Path.basename(filename)}]}, []}]}
  end

  defp format(options) do
    case get_in(options, [:html]) do
      true -> "html"
      _ -> nil
    end
  end
end
