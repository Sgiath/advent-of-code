defmodule AdventOfCode.Year2019.Day06 do
  @moduledoc """
  https://adventofcode.com/2019/day/6
  """
  use AdventOfCode, year: 2019, day: 6

  @impl AdventOfCode
  def test_input do
    """
    COM)B
    B)C
    C)D
    D)E
    E)F
    B)G
    G)H
    D)I
    E)J
    J)K
    K)L
    """
  end

  @impl AdventOfCode
  def part1(input) do
    graph =
      input
      |> String.split(["\n", ")"], trim: true)
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn [anchor, orbit], acc ->
        Map.update(acc, anchor, [orbit], &[orbit | &1])
      end)

    graph
    |> Map.get("COM")
    |> compute_orbits(graph, 0)
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split(["\n", ")"], trim: true)
    |> Enum.chunk_every(2)
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
