defmodule AdventOfCode.Year2019.Day06 do
  @moduledoc """
  https://adventofcode.com/2019/day/6
  """
  use AdventOfCode, year: 2019, day: 06

  @doc """
  What is the total number of direct and indirect orbits in your map data?
  """
  @impl AdventOfCode
  def part1 do
    graph =
      input_lines()
      |> Stream.map(&String.split(&1, ")"))
      |> Enum.reduce(%{}, fn [anchor, orbit], acc ->
        Map.update(acc, anchor, [orbit], fn orbits -> [orbit | orbits] end)
      end)

    graph
    |> Map.get("COM")
    |> compute_orbits(graph, 0)
  end

  @doc """
  What is the minimum number of orbital transfers required to move from the object YOU are
  orbiting to the object SAN is orbiting? (Between the objects they are orbiting - not between
  YOU and SAN.)
  """
  @impl AdventOfCode
  def part2 do
    input_lines()
    |> Stream.map(&String.split(&1, ")"))
    |> Enum.reduce(Graph.new(), fn [anchor, orbit], graph ->
      graph
      |> Graph.add_edge(anchor, orbit)
      |> Graph.add_edge(orbit, anchor)
    end)
    |> Graph.dijkstra("SAN", "YOU")
    |> Enum.count()
    |> Kernel.-(3)
  end

  @doc """
  Compute all direct and indirect orbits
  """
  @spec compute_orbits(list() | nil, map(), integer()) :: integer()
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
