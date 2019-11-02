defmodule ExIdobata.API.Query do
  @moduledoc """
  Define queries for GraphQL API of idobata.io.
  """
  @moduledoc since: "0.2.0"

  @viewer_query "query { viewer { name } }"
  @rooms_query "query { viewer { rooms { edges { node { id name organization { slug } } } } } }"
  @post_query """
  mutation ($source: String!) {
    createMessage(input: {
      roomId: "<%= room_id %>",
      source: $source,
      format: <%= format %>
    }) {
      clientMutationId
    }
  }
  """

  @type format :: :plain | :markdown | :html

  @doc """
  Determines if `format` is `t:format/0`.

  Allowed in guard clauses.
  """
  defguard is_format(format) when format in [:plain, :markdown, :html]

  require EEx

  @doc false
  @spec viewer :: binary()
  EEx.function_from_string(:def, :viewer, @viewer_query)

  @doc false
  @spec rooms :: binary()
  EEx.function_from_string(:def, :rooms, @rooms_query)

  @doc false
  @spec post(binary(), binary()) :: binary()
  EEx.function_from_string(:def, :post, @post_query, [:room_id, :format])
end
