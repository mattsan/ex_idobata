defmodule ExIdobata do
  @moduledoc """
  An [Idobata.io](https://idobata.io/home) client in Elixir.
  """

  alias ExIdobata.Endpoint

  @endpoint_url Application.get_env(:ex_idobata, :endpoint_url) || ""

  @spec new_hook(String.t()) :: Endpoint.t()
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
  @spec post(Endpoint.t(), Keyword.t()) :: {:ok, integer, String.t()} | {:error, any}
  def post(%Endpoint{} = endpoint \\ %Endpoint{url: @endpoint_url}, fields) do
    forms = fields |> Enum.reduce([], &build_form/2)

    case HTTPoison.post(endpoint.url, {:multipart, forms}, [], [ssl: [{:versions, [:'tlsv1.2']}]]) do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        {:ok, status_code, body}

      {:error, error} ->
        {:error, Exception.message(error)}
    end
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
