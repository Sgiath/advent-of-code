defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:nx, "~> 0.6"},
      {:exla, "~> 0.6"},
      {:req, "~> 0.4"},
      {:benchee, "~> 1.2", only: [:dev, :test]},
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false}
    ]
  end
end
