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
  @moduledoc since: "0.1.0"

  alias ExIdobata.Hook.{Endpoint, Contents}

  @http_client Application.get_env(:ex_idobata, :http_client, HTTPoison)

  @doc """
  Post contents to idobata.io with default hook API.

  This uses default UUID. see `post/2`.
  """
  @doc since: "0.1.0"
  @spec post(Contents.t()) :: any()
  def post(%Contents{} = contents) do
    post(contents, :default)
  end

  @doc """
  Post contents to idobata.io with hook API.

  - `contents` - Contents to post to idobata.io
  - `room_uuid` - UUID of a room of idobata.io to be post. see `ExIdobata.Hook.Endpoint.url/1`
  """
  @doc since: "0.1.0"
  @spec post(Contents.t(), Endpoint.room_uuid()) :: any()
  def post(%Contents{} = contents, room_uuid) do
    @http_client.post(
      Endpoint.url(room_uuid),
      {:multipart, contents.parts},
      [],
      ssl: [{:versions, [:"tlsv1.2"]}]
    )
  end

  @doc """
  Initialize contents to post
  """
  @doc since: "0.1.0"
  @spec contents :: Contents.t()
  defdelegate contents, to: Contents

  @doc """
  Initialize contents to post with patrs


  - `:source` - source text
  - `:format` - format of the source text (`:markdown` or `:html`)
  - `:image` - filename of image file

  ## Example

  ```elixir
  ExIdobata.Hook.contents(source: "**Hi!**", format: :markdown, image: "./hello.gif")
  ```

  This is same as:

  ```elixir
  ExIdobata.Hook.contents()
  |> ExIdobata.Hook.source("**Hi!**")
  |> ExIdobata.Hook.markdown()
  |> ExIdobata.Hook.image("./hello.gif")
  ```
  """
  @doc since: "0.1.0"
  @spec contents(Keyword.t()) :: Contents.t()
  defdelegate contents(params), to: Contents

  @doc """
  Set a source text in the contents.
  """
  @doc since: "0.1.0"
  @spec source(Contents.t(), binary()) :: Contents.t()
  defdelegate source(contents, source), to: Contents

  @doc """
  Set format of the source Markdown in the contents.
  """
  @doc since: "0.1.0"
  @spec markdown(Contents.t()) :: Contents.t()
  def markdown(contents) do
    Contents.format(contents, "markdown")
  end

  @doc """
  Set format of the source HTML in the contents.
  """
  @doc since: "0.1.0"
  @spec html(Contents.t()) :: Contents.t()
  def html(contents) do
    Contents.format(contents, "html")
  end

  @doc """
  Set an image into the contents from a file.
  """
  @doc since: "0.1.0"
  @spec image(Contents.t(), binary()) :: Contents.t()
  defdelegate image(contents, filename), to: Contents

  @doc """
  Set an image into the contents from a binary string.
  """
  @doc since: "0.3.0"
  @spec image(Contents.t(), binary(), binary()) :: Contents.t()
  defdelegate image(contents, filename, body), to: Contents
end
