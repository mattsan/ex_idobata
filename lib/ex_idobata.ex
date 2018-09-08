defmodule ExIdobata do
  @moduledoc """
  An [Idobata.io](https://idobata.io/home) client in Elixir.
  """

  defstruct [:url]

  @type t :: %ExIdobata{}

  @spec new_hook(String.t()) :: ExIdobata.t()
  @doc """
  Get hook data of Idobata.io.
  """
  def new_hook(url) do
    %ExIdobata{url: url}
  end

  @doc """
  Post a message to Idobata.io.

  ## option

  - `:html` - set `true`, `message` is post as HTML.
  """
  @spec post_message(ExIdobata.t(), String.t(), Keyword.t()) :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t}
  def post_message(%ExIdobata{url: url}, message, options \\ []) do
    headers = ["Content-Type": "application/x-www-form-urlencoded"]

    encoded_message = URI.encode_www_form(message)
    body = if get_in(options, [:html]) do
        "source=#{encoded_message}&format=html"
      else
        "source=#{encoded_message}"
      end

    HTTPoison.post(url, body, headers)
  end

  @doc """
  Post an image to Idobata.io from image file.
  """
  @spec post_image_file(ExIdobata.t(), String.t()) :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t}
  def post_image_file(%ExIdobata{url: url}, filename) do
    HTTPoison.post(url, muptipart_image(filename))
  end

  defp muptipart_image(filename) do
    {:multipart, [{:file, filename, {"form-data", [{"name", "image"}, {"filename", Path.basename(filename)}]}, []}]}
  end
end
