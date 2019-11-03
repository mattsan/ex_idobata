defmodule ExIdobata.Hook.ContentsTest do
  use ExUnit.Case
  doctest ExIdobata.Hook.Contents

  alias ExIdobata.Hook.Contents

  defp image_part(full_path, filename) do
    {
      :file,
      full_path,
      {
        "form-data",
        [
          {"name", "image"},
          {"filename", filename}
        ]
      },
      []
    }
  end

  describe "contents" do
    test "empty" do
      assert Contents.contents() == %Contents{parts: []}
    end

    test "parameter source" do
      assert Contents.contents(source: "foo") == %Contents{parts: [{"source", "foo"}]}
    end

    test "parameter format" do
      assert Contents.contents(format: :html) == %Contents{parts: [{"format", "html"}]}
    end

    test "parameter image" do
      expected = %Contents{parts: [image_part(Path.expand("./bar.jpg"), "bar.jpg")]}
      assert Contents.contents(image: "./bar.jpg") == expected
    end

    test "parameters source, foramt and image" do
      source_part = {"source", "foo"}
      format_part = {"format", "markdown"}

      expected = %Contents{
        parts: [image_part(Path.expand("./bar.jpg"), "bar.jpg"), format_part, source_part]
      }

      assert Contents.contents(source: "foo", format: :markdown, image: "./bar.jpg") == expected
    end
  end

  describe "combination of source, format and image" do
    setup do
      [contents: Contents.contents()]
    end

    test "append a source", %{contents: contents} do
      assert contents |> Contents.source("foo") == %Contents{parts: [{"source", "foo"}]}
    end

    test "append multipul sources", %{contents: contents} do
      assert contents |> Contents.source("foo") |> Contents.source("bar") ==
               %Contents{parts: [{"source", "bar"}, {"source", "foo"}]}
    end

    test "append a format", %{contents: contents} do
      assert contents |> Contents.format("html") == %Contents{parts: [{"format", "html"}]}
    end

    test "append multipul formats", %{contents: contents} do
      assert contents |> Contents.format("html") |> Contents.format("markdown") ==
               %Contents{parts: [{"format", "markdown"}, {"format", "html"}]}
    end

    test "append a image", %{contents: contents} do
      expected = %Contents{parts: [image_part(Path.expand("./foo.jpg"), "foo.jpg")]}
      assert contents |> Contents.image("./foo.jpg") == expected
    end

    test "append multipul images", %{contents: contents} do
      expected = %Contents{
        parts: [
          image_part(Path.expand("./bar.jpg"), "bar.jpg"),
          image_part(Path.expand("./foo.jpg"), "foo.jpg")
        ]
      }

      assert contents |> Contents.image("./foo.jpg") |> Contents.image("./bar.jpg") == expected
    end

    test "append a source, format and image", %{contents: contents} do
      expected = %Contents{
        parts: [
          image_part(Path.expand("./foo.jpg"), "foo.jpg"),
          {"format", "markdown"},
          {"source", "foo bar"}
        ]
      }

      assert contents
             |> Contents.source("foo bar")
             |> Contents.format("markdown")
             |> Contents.image("./foo.jpg") == expected
    end
  end
end
