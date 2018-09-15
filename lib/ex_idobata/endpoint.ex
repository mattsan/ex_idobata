defmodule ExIdobata.Endpoint do
  defstruct [:url]

  @type t :: %ExIdobata.Endpoint{url: String.t()}
end
