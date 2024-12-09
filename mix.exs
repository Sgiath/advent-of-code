defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "2024.3.2",
      elixir: "~> 1.17",
      start_permanent: false,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger, :eex, :tools]]

  defp deps do
    [
      # used in solutions
      {:flow, "~> 1.2"},
      {:typed_struct, "~> 0.3"},
      {:libgraph, "~> 0.16"},
      {:statistics, "~> 0.6"},
      {:nimble_parsec, "~> 1.4"},

      # fast math
      {:nx, "~> 0.9"},
      {:exla, "~> 0.9"},

      # download inputs
      {:req, "~> 0.5"},

      # benchmarking and testing
      {:benchee, "~> 1.3", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.2", only: :dev, runtime: false}
    ]
  end
end
