defmodule ExIdobata.Hook.Endpoint do
  @moduledoc false

  @port 443
  @scheme "https"
  @host "idobata.io"
  @hook_path "/hook/custom"

  @spec path(binary()) :: binary()
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
