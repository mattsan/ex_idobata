defmodule ExIdobata.Hook.Contents do
  @moduledoc """
  Container for contents of to post idobata.io
  """
  @moduledoc since: "0.1.0"

  defstruct parts: []

  @type source :: {binary(), binary()}
  @type format :: {binary(), binary()}
  @type image :: {:file, binary(), tuple(), list()}
  @type blob :: {binary(), binary(), tuple(), list()}
  @type part :: source() | format() | image()
  @type t :: %__MODULE__{
          parts: [part()]
        }

  alias ExIdobata.Hook.Contents

  @doc since: "0.1.0"
  @spec contents :: t()
  def contents do
    %Contents{}
  end

  @doc since: "0.1.0"
  @spec contents([part()]) :: t()
  def contents(params) when is_list(params) do
    parts =
      params
      |> Enum.reduce([], fn
        {:source, src}, acc -> [source(src) | acc]
        {:format, fmt}, acc -> [format(fmt) | acc]
        {:image, filename}, acc -> [image(filename) | acc]
      end)

    %Contents{parts: parts}
  end

  @doc since: "0.1.0"
  @spec source(t(), binary()) :: t()
  def source(%Contents{parts: parts} = contents, src) when is_binary(src) do
    %Contents{contents | parts: [source(src) | parts]}
  end

  @doc since: "0.1.0"
  @spec format(t(), binary() | atom()) :: t()
  def format(%Contents{parts: parts} = contents, fmt) when is_binary(fmt) or is_atom(fmt) do
    %Contents{contents | parts: [format(fmt) | parts]}
  end

  @doc since: "0.1.0"
  @spec image(t(), binary()) :: t()
  def image(%Contents{parts: parts} = contents, filename) when is_binary(filename) do
    %Contents{contents | parts: [image(filename) | parts]}
  end

  @doc since: "0.3.0"
  @spec image(t(), binary(), binary()) :: t()
  def image(%Contents{parts: parts} = contents, filename, body)
      when is_binary(filename) and is_binary(body) do
    content_type = :mimerl.filename(filename)
    %Contents{contents | parts: [blob(filename, body, "image", content_type) | parts]}
  end

  @doc since: "0.1.0"
  @spec source(binary()) :: source()
  def source(src) when is_binary(src), do: {"source", src}

  @doc since: "0.1.0"
  @spec format(binary() | atom) :: format()
  def format(fmt) when is_binary(fmt), do: {"format", fmt}
  def format(fmt) when is_atom(fmt), do: {"format", Atom.to_string(fmt)}

  @doc since: "0.1.0"
  @spec image(binary()) :: image()
  def image(filename) when is_binary(filename) do
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

  @doc since: "0.3.0"
  @spec blob(binary(), binary(), binary(), binary()) :: blob()
  def blob(filename, binary, name, content_type)
      when is_binary(binary) and is_binary(binary) and is_binary(name) and is_binary(content_type) do
    {
      "blob",
      binary,
      {
        "form-data",
        [
          {"name", name},
          {"filename", filename}
        ]
      },
      [{"Content-Type", content_type}]
    }
  end
end
