ExUnit.start()

defmodule ExIdobata.Mock.HTTPClient do
  def post(url, body, headers, options) do
    IO.write("""
    url: '#{url}'
    body: '#{inspect(body)}'
    headers: '#{inspect(headers)}'
    options: '#{inspect(options)}'
    """)
  end
end
