defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:flow, "~> 1.1"},
      {:typed_struct, "~> 0.2"},
      {:libgraph, "~> 0.13"}
    ]
  end
end
