defmodule ExIdobata do
  @moduledoc """
  An [Idobata.io](https://idobata.io/home) client in Elixir.
  """

  defmodule Endpoint do
    defstruct [:url]
  end

  alias ExIdobata.Endpoint

  @type t :: %Endpoint{}
  @type httpoison_result :: {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()} | {:error, HTTPoison.Error.t()}

  @spec new_hook(String.t()) :: Endpoint.t()
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
  @spec post_message(Endpoint.t(), String.t(), Keyword.t()) :: httpoison_result
  def post_message(%Endpoint{url: url}, message, options \\ []) do
    headers = ["Content-Type": "application/x-www-form-urlencoded"]

    encoded_message = URI.encode_www_form(message)

    body =
      if get_in(options, [:html]) do
        "source=#{encoded_message}&format=html"
      else
        "source=#{encoded_message}"
      end

    HTTPoison.post(url, body, headers)
  end

  @doc """
  Post an image to Idobata.io from image file.
  """
  @spec post_image_file(Endpoint.t(), String.t()) :: httpoison_result
  def post_image_file(%Endpoint{url: url}, filename) do
    HTTPoison.post(url, muptipart_image(filename))
  end

  defp muptipart_image(filename) do
    {:multipart, [{:file, filename, {"form-data", [{"name", "image"}, {"filename", Path.basename(filename)}]}, []}]}
  end
end
