defmodule ExIdobata do
  defstruct [:url]

  def new_hook(url) do
    %ExIdobata{url: url}
  end

  def post_message(%ExIdobata{url: url}, message, options \\ []) do
    headers = ["Content-Type": "application/x-www-form-urlencoded"]

    encoded_message = URI.encode_www_form(message)
    body = if get_in(options, [:html]) do
        "source=#{encoded_message}&format=html"
      else
        "source=#{encoded_message}"
      end

    HTTPoison.post(url, body, headers)
  end

  def post_image_file(%ExIdobata{url: url}, filename) do
    HTTPoison.post(url, muptipart_image(filename))
  end

  defp muptipart_image(filename) do
    {:multipart, [{:file, filename, {"form-data", [{"name", "image"}, {"filename", Path.basename(filename)}]}, []}]}
  end
end
