defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
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
      {:flow, "~> 1.1"},
      {:typed_struct, "~> 0.2"},
      {:libgraph, "~> 0.13"},
      {:statistics, "~> 0.6"},
      {:benchee, "~> 1.0", only: :dev},
      {:credo, "~> 1.6", only: :dev, runtime: false}
    ]
  end
end
