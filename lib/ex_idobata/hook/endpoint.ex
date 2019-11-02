defmodule ExIdobata.Hook.Endpoint do
  @moduledoc """
  Endpoint structure of ExIdobata.
  """

  @port 443
  @scheme "https"
  @host "idobata.io"
  @hook_path "/hook/custom"
  @default_env_var "IDOBATA_HOOK_ROOM_UUID"

  @type room_uuid :: binary() | {:system, binary()} | :default

  @spec path(room_uuid()) :: binary()
  @doc """
  Get a path of idobata.io hook API.

  - `room_uuid` - UUID of a room of idobata.io
    - binary - use the binary as UUID
    - tuple of `:system` and binary (e.g., `{:system, "ROOM_UUID"}` - use value of the environment variable as UUID
    - `:default` - use value of default environemnt variable `IDOBATA_HOOK_ROOM_UUID` as UUID
  """
  def path(room_uuid)

  def path(:default) do
    path({:system, @default_env_var})
  end

  def path({:system, env_var}) when is_binary(env_var) do
    env_var
    |> System.get_env()
    |> path()
  end

  def path(room_uuid) when is_binary(room_uuid) do
    %URI{
      port: @port,
      scheme: @scheme,
      host: @host,
      path: Path.join(@hook_path, room_uuid)
    }
    |> URI.to_string()
  end
end
