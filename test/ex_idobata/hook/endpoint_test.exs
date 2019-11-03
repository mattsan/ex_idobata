defmodule ExIdobata.Hook.EndpointTest do
  use ExUnit.Case
  doctest ExIdobata.Hook.Endpoint

  alias ExIdobata.Hook.Endpoint

  describe "url" do
    setup context do
      envs = context[:put_env]

      if envs do
        prev_envs =
          envs
          |> Enum.map(fn {key, value} ->
            prev_value = System.get_env(key)
            System.put_env(key, value)
            {key, prev_value}
          end)

        on_exit(fn ->
          prev_envs
          |> Enum.each(fn
            {key, nil} -> System.delete_env(key)
            {key, value} -> System.put_env(key, value)
          end)
        end)
      end

      :ok
    end

    test "room_uuid" do
      assert Endpoint.url("room-uuid") == "https://idobata.io/hook/custom/room-uuid"
    end

    @tag put_env: [{"ROOM_UUID", "my-room-uuid"}]
    test "{:system, ROOM_UUID}" do
      assert Endpoint.url({:system, "ROOM_UUID"}) == "https://idobata.io/hook/custom/my-room-uuid"
    end

    @tag put_env: [{"IDOBATA_HOOK_ROOM_UUID", "default-room-uuid"}]
    test ":default" do
      assert Endpoint.url(:default) == "https://idobata.io/hook/custom/default-room-uuid"
    end
  end
end
