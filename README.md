# ExIdobata

An [Idobata.io](https://idobata.io/en/home) ([Japanese](https://idobata.io/ja/home)) client in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_idobata` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_idobata, "~> 0.1"}
  ]
end
```

## Hook

To post messages or images to use hook API.

### Usage

```elixir
alias ExIdobata.Hook
```

```elixir
# room UUID, it's the last part of hook API,
# for examle https://idobata.io/hook/custom/00000000-0000-0000-0000-000000000000

room_uuid = "00000000-0000-0000-0000-000000000000"
```

```elixir
# post plain text message

Hook.contents()
|> Hook.source("Hi")
|> Hook.post(room_uuid)

# post Markdown message

Hook.contents()
|> Hook.source("# Hi")
|> Hook.markdown()
|> Hook.post(room_uuid)

# post HTML message

Hook.contents()
|> Hook.source("<h1>Hi</h1>")
|> Hook.html()
|> Hook.post(room_uuid)

# post message with image

Hook.contents()
|> Hook.source("hi")
|> Hook.image("./hello.gif")
|> Hook.post(room_uuid)
```

#### Use environment variable

If `room_uuid` omitted, the function `post` uses a value of environemnt variable `IDOBATA_HOOK_ROOM_UUID` as UUID.
To use another environment variable, pass a tuple with `:system` and the variable name (e.g., `{:system, "ANOTHER_ROOM_UUID"}`).

## GraphQL API

### Gets an access token

```elixir
access_token = ExIdobata.API.AccessToken.get(email, password)
```

This access token used API functions described below.

### Gets a viewer

```elixir
viewer = ExIdobata.API.Viewer.get(access_token)
# `viewer.name` is an account user name
```

### Gets rooms

```elixir
rooms = ExIdobata.API.Room.get(access_token)
```

### Posts a message

To post a plain text message.

```elixir
ExIdobata.API.post(access_token, room, "Hi")
```

It's same as bellow.

```elixir
ExIdobata.API.post(access_token, room, "Hi", :plain)
```

To post a Markdown message.

```elixir
ExIdobata.API.post(access_token, room, "*Hi*", :markdown)
```

To post a HTML message.

```elixir
ExIdobata.API.post(access_token, room, "<h1>Hi</h1>", :html)
```
