defmodule ExIdobata.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_idobata,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:ex_doc, "~> 0.21", only: :dev, autoload: false},
      {:dialyxir, "~> 0.5", only: :dev, autoload: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme"
    ]
  end
end
