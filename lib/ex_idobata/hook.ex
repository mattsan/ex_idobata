defmodule ExIdobata.Hook do
  @moduledoc """
  Post contents with a hook endpoint with idobata.io.

  ## Example

  ```elixir
  alias ExIdobata.Hook

  Hook.contents()
  |> Hook.source("# Hello!")
  |> Hook.format(:markdown)
  |> Hook.file("./hello.gif")
  |> Hook.post(room_uuid)

  # or

  Hook.contents(source: "# Hello!, format: :markdown, file: "./hello.gif")
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
  Set format of the source in the contents.
  """
  @spec format(Contents.t(), binary()) :: Contents.t()
  defdelegate format(contents, format), to: Contents

  @doc """
  Append a file into the contents.
  """
  @spec file(Contents.t(), binary()) :: Contents.t()
  defdelegate file(contents, filename), to: Contents
end
