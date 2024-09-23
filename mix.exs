defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "2023.19.1",
      elixir: "~> 1.17",
      start_permanent: false,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  defp deps do
    [
      {:flow, "~> 1.2"},
      {:typed_struct, "~> 0.3"},
      {:libgraph, "~> 0.16"},
      {:statistics, "~> 0.6"},
      {:nimble_parsec, "~> 1.4"},
      {:nx, "~> 0.8"},
      {:exla, "~> 0.8"},
      {:req, "~> 0.5"},
      {:benchee, "~> 1.3", only: [:dev, :test]},
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.2", only: :dev, runtime: false}
    ]
  end
end
