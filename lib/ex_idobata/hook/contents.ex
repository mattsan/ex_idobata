defmodule ExIdobata.Hook.Contents do
  @moduledoc """
  A container for contents of to post idobata.io
  """

  defstruct [parts: []]

  @type source :: {binary(), binary()}
  @type format :: {binary(), binary()}
  @type file :: {:file, binary(), tuple(), list()}
  @type part :: source() | format() | file()
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
      |> Enum.map(fn
        {:source, src} -> source(src)
        {:format, fmt} -> format(fmt)
        {:file, filename} -> file(filename)
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

  @spec file(t(), binary()) :: t()
  def file(%Contents{parts: parts} = contents, filename) when is_binary(filename) do
    %Contents{contents |
      parts: [file(filename) | parts]
    }
  end

  @spec source(binary()) :: source()
  def source(src) when is_binary(src), do: {"source", src}

  @spec format(binary() | atom) :: format()
  def format(fmt) when is_binary(fmt), do: {"format", fmt}
  def format(fmt) when is_atom(fmt), do: {"format", Atom.to_string(fmt)}

  @spec file(binary()) :: file()
  def file(filename) when is_binary(filename) do
    {
      :file,
      Path.expand(filename),
      {
        "form-data",
        [
          {"name", "file"},
          {"filename", Path.basename(filename)}
        ]
      },
      []
    }
  end
end
