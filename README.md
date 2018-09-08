# ExIdobata

An [Idobata.io](https://idobata.io/home) client in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_idobata` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_idobata, github: "mattsan/ex_idobata.git"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_idobata](https://hexdocs.pm/ex_idobata).

## Usage

```elixir
endpoint = ExIdobata.new_hook("https://idobata.io/hook/custom/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
```

Post a message.

```elixir
endpoint |> ExIdoata.post_message("Hello!")
```

Post a message as HTML.

```elixir
endpoint |> ExIdoata.post_message("<h1>Hello!</h1>", html: true)
```

Post an image file.

```elixir
endpoint |> ExIdoata.post_image_file("/path/to/image.png")
```
