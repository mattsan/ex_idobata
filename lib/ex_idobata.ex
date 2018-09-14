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

  ## option

  - `:text` - post an image with a plain text
  - `:html` - post an image with an HTML
  """
  @spec post_image_file(endpoint, String.t(), Keyword.t()) :: httpoison_result
  def post_image_file(%Endpoint{url: url}, filename, options \\ []) do
    HTTPoison.post(url, muptipart_image(filename, options))
  end

  defp muptipart_image(filename, options) do
    {:multipart, []}
    |> append_file(filename)
    |> append_text(options)
    |> append_html(options)
  end

  defp append_file({:multipart, forms}, filename) do
    file_form = {
      :file,
      Path.expand(filename),
      {
        "form-data",
        [
          {"name", "image"},
          {"filename", Path.basename(filename)}
        ]
      },
      []
    }

    {:multipart, [file_form | forms]}
  end

  defp append_text({:multipart, forms} = multipart, options) do
    case get_in(options, [:text]) do
      nil -> multipart
      text -> {:multipart, [{"source", text} | forms]}
    end
  end

  defp append_html({:multipart, forms} = multipart, options) do
    case get_in(options, [:html]) do
      nil -> multipart
      html -> {:multipart, [{"source", html}, {"format", "html"} | forms]}
    end
  end

  defp format(options) do
    case get_in(options, [:html]) do
      true -> "html"
      _ -> nil
    end
  end
end
