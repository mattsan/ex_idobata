defmodule ExIdobata do
  @moduledoc """
  An [Idobata.io](https://idobata.io/home) client in Elixir.
  """

  defmodule Endpoint do
    defstruct [
      url: Application.get_env(:ex_idobata, :endpoint_url)
    ]
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
  Post contents to Idobata.io.

  ## contents options

  - `:source` - A text to post.
  - `:format` - A format of the text.
      - `:plain` - plain text (default)
      - `:html` - HTML
      - `:markdown` - Markdown
  - `:file` - An image file to post.
  """
  @spec post(endpoint, Keyword.t()) :: httpoison_result
  def post(%Endpoint{url: url} \\ %Endpoint{}, fields) do
    forms = fields |> Enum.reduce([], &build_form/2)

    HTTPoison.post(url, {:multipart, forms})
  end

  defp build_form({:image, filename}, forms), do: [file_form(filename) | forms]
  defp build_form({:source, source}, forms), do: [{"source", source} | forms]
  defp build_form({:format, format}, forms), do: [{"format", Atom.to_string(format)} | forms]
  defp build_form(_, forms), do: forms

  defp file_form(filename) do
    {
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
  end
end
