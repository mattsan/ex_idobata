defmodule ExIdobata.Hook do
  @moduledoc """
  Post contents with a hook endpoint with idobata.io.

  ## Example

  ```elixir
  alias ExIdobata.Hook

  Hook.contents()
  |> Hook.source("# Hello!")
  |> Hook.markdown()
  |> Hook.image("./hello.gif")
  |> Hook.post(room_uuid)

  # or

  Hook.contents(source: "# Hello!, format: :markdown, image: "./hello.gif")
  |> Hook.post(room_uuid)
  ```
  """

  alias ExIdobata.Hook.{Endpoint, Contents}

  @doc """
  Post contents to idobata.io with hook API.
  """
  @spec post(Contents.t(), binary()) :: any()
  def post(%Contents{} = contents, room_uuid) when is_binary(room_uuid) do
    HTTPoison.post(
      Endpoint.path(room_uuid),
      {:multipart, contents.parts},
      [],
      ssl: [{:versions, [:"tlsv1.2"]}]
    )
  end

  @doc """
  Initialize contents to post
  """
  @spec contents :: Contents.t()
  defdelegate contents, to: Contents

  @doc """
  Initialize contents to post with patrs
  """
  @spec contents(Keyword.t()) :: Contents.t()
  defdelegate contents(params), to: Contents

  @doc """
  Set a source text in the contents.
  """
  @spec source(Contents.t(), binary()) :: Contents.t()
  defdelegate source(contents, source), to: Contents

  @doc """
  Set format of the source Markdown in the contents.
  """
  @spec markdown(Contents.t()) :: Contents.t()
  def markdown(contents) do
    Contents.format(contents, "markdown")
  end

  @doc """
  Set format of the source HTML in the contents.
  """
  @spec html(Contents.t()) :: Contents.t()
  def html(contents) do
    Contents.format(contents, "html")
  end

  @doc """
  Set an image into the contents.
  """
  @spec image(Contents.t(), binary()) :: Contents.t()
  defdelegate image(contents, filename), to: Contents
end
