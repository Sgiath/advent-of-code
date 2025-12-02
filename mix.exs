defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "2025.12.1",
      elixir: "~> 1.19",
      start_permanent: false,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def cli do
    [preferred_envs: [precommit: :test]]
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
      {:nx, "~> 0.10"},
      {:exla, "~> 0.10"},

      # download inputs
      {:req, "~> 0.5"},

      # benchmarking and testing
      {:benchee, "~> 1.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.4", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      precommit: ["compile --warning-as-errors", "deps.unlock --unused", "format", "test"]
    ]
  end
end
