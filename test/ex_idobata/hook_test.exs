defmodule ExIdobata.HookTest do
  use ExUnit.Case
  doctest ExIdobata.Hook

  import ExUnit.CaptureIO

  alias ExIdobata.Hook
  alias ExIdobata.Hook.Contents

  describe "content" do
    test "empty" do
      assert Hook.contents() == %Contents{parts: []}
    end

    test "with paramaters" do
      assert Hook.contents(source: "foo", format: :markdown) ==
               %Contents{parts: [{"format", "markdown"}, {"source", "foo"}]}
    end
  end

  describe "source, formats and image" do
    setup do
      [contents: Hook.contents()]
    end

    test "markddown", %{contents: contents} do
      assert contents |> Hook.markdown() == %Contents{parts: [{"format", "markdown"}]}
    end

    test "html", %{contents: contents} do
      assert contents |> Hook.html() == %Contents{parts: [{"format", "html"}]}
    end

    test "iamge", %{contents: contents} do
      assert contents |> Hook.image("./bar.jpg") ==
               %Contents{
                 parts: [
                   {
                     :file,
                     Path.expand("./bar.jpg"),
                     {"form-data",
                      [
                        {"name", "image"},
                        {"filename", "bar.jpg"}
                      ]},
                     []
                   }
                 ]
               }
    end
  end

  describe "post" do
    test "post a source" do
      expected = """
      url: 'https://idobata.io/hook/custom/room-uuid'
      body: '{:multipart, [{"source", "Hi"}]}'
      headers: '[]'
      options: '[ssl: [versions: [:"tlsv1.2"]]]'
      """

      assert capture_io(fn ->
               Hook.contents(source: "Hi") |> Hook.post("room-uuid")
             end) == expected
    end

    test "post an image" do
      expected = """
      url: 'https://idobata.io/hook/custom/room-uuid'
      body: '{:multipart, [{:file, "#{Path.expand("./foo.jpg")}", {"form-data", [{"name", "image"}, {"filename", "foo.jpg"}]}, []}]}'
      headers: '[]'
      options: '[ssl: [versions: [:"tlsv1.2"]]]'
      """

      assert capture_io(fn ->
               Hook.contents()
               |> Hook.image("./foo.jpg")
               |> Hook.post("room-uuid")
             end) == expected
    end
  end
end
