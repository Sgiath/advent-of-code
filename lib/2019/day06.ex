defmodule AdventOfCode.Year2019.Day06 do
  @moduledoc """
  https://adventofcode.com/2019/day/6
  """
  use AdventOfCode, year: 2019, day: 06

  @impl AdventOfCode
  def input, do: Enum.map(input_lines(), &String.split(&1, ")"))

  @impl AdventOfCode
  def part1(input) do
    graph =
      Enum.reduce(input, %{}, fn [anchor, orbit], acc ->
        Map.update(acc, anchor, [orbit], fn orbits -> [orbit | orbits] end)
      end)

    graph
    |> Map.get("COM")
    |> compute_orbits(graph, 0)
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> Enum.reduce(Graph.new(), fn [anchor, orbit], graph ->
      graph
      |> Graph.add_edge(anchor, orbit)
      |> Graph.add_edge(orbit, anchor)
    end)
    |> Graph.dijkstra("SAN", "YOU")
    |> Enum.count()
    |> Kernel.-(3)
  end

  def compute_orbits(nil, _graph, value), do: value

  def compute_orbits(orbits, graph, value) do
    Enum.reduce(orbits, value, fn orbit, acc ->
      graph
      |> Map.get(orbit)
      |> compute_orbits(graph, value + 1)
      |> Kernel.+(acc)
    end)
  end
end
