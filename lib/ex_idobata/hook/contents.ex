defmodule ExIdobata.Hook.Contents do
  @moduledoc """
  A container for contents of to post idobata.io
  """

  defstruct [parts: []]

  @type source :: {binary(), binary()}
  @type format :: {binary(), binary()}
  @type image :: {:file, binary(), tuple(), list()}
  @type part :: source() | format() | image()
  @type t :: %__MODULE__{
    parts: [part()]
  }

  alias ExIdobata.Hook.Contents

  @spec contents :: t()
  def contents do
    %Contents{}
  end

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

  @spec source(t(), binary()) :: t()
  def source(%Contents{parts: parts} = contents, src) when is_binary(src) do
    %Contents{contents |
      parts: [source(src) | parts]
    }
  end

  @spec format(t(), binary() | atom()) :: t()
  def format(%Contents{parts: parts} = contents, fmt) when is_binary(fmt) or is_atom(fmt) do
    %Contents{contents |
      parts: [format(fmt) | parts]
    }
  end

  @spec image(t(), binary()) :: t()
  def image(%Contents{parts: parts} = contents, filename) when is_binary(filename) do
    %Contents{contents |
      parts: [image(filename) | parts]
    }
  end

  @spec source(binary()) :: source()
  def source(src) when is_binary(src), do: {"source", src}

  @spec format(binary() | atom) :: format()
  def format(fmt) when is_binary(fmt), do: {"format", fmt}
  def format(fmt) when is_atom(fmt), do: {"format", Atom.to_string(fmt)}

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
end
