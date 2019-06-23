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

## configration

Set a default url.

```elixir
config :ex_idobata, 
  endpoint_url: "https://idobata.io/hook/custom/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## Usage

```elixir
endpoint = ExIdobata.new_hook("https://idobata.io/hook/custom/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
```

or

```elixir
endpoint = ExIdobata.new_hook() # use a default url set in config.exs
```

### Post a message.

```elixir
endpoint |> ExIdoata.post(source: "Hello!")
```

### Post a message as HTML.

```elixir
endpoint |> ExIdoata.post(source: "<h1>Hello!</h1>", format: :html)
```

### Post a message as Markdown.

```elixir
endpoint |> ExIdoata.post(source: "# Hello!", format: :markdown)
```

### Post an image file.

```elixir
endpoint |> ExIdoata.post(image: "/path/to/image.png")
```

Text (Markdown) and Image:

```elixir
endpoint |> ExIdoata.post(source: "This is a **PNG** image.", format: :markdown, image: "/path/to/image.png")
```
