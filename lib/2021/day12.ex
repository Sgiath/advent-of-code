defmodule AdventOfCode.Year2021.Day12 do
  @moduledoc """
  https://adventofcode.com/2021/day/12
  """
  use AdventOfCode, year: 2021, day: 12

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """
  end

  def parse(input) do
    input
    |> String.split(["\n", "-"], trim: true)
    |> Enum.chunk_every(2)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> neighbors()
    |> find_paths()
    |> List.flatten()
    |> length()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> neighbors()
    |> find_paths(false)
    |> List.flatten()
    |> length()
  end

  @doc """
  Find all paths in graph

  Second argument indicates if the small cave was already used twice (defualt is `true` which means
  it will not go twice to any small cave)
  """
  def find_paths(graph, twice? \\ true, path \\ ["start"])
  def find_paths(_graph, _twice?, ["end" | _path]), do: :ok

  def find_paths(graph, twice?, [point | _rest] = path) do
    graph[point]
    |> Enum.reject(&avoid?(&1, path, twice?))
    |> Enum.map(&find_paths(graph, twice? or avoid?(&1, path, true), [&1 | path]))
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Construct map with vertices as keys and list of neighbor vertecies as values

  ## Examples

      iex> paths = [["a", "b"], ["a", "c"]]
      iex> AdventOfCode.Year2021.Day12.neighbors(paths)
      %{
        "a" => ["c", "b"],
        "b" => ["a"],
        "c" => ["a"]
      }
  """
  def neighbors(paths, neigh \\ %{})

  def neighbors([[a, b] | paths], neigh) do
    neigh
    |> Map.update(a, [b], &[b | &1])
    |> Map.update(b, [a], &[a | &1])
    |> then(&neighbors(paths, &1))
  end

  def neighbors([], neigh), do: neigh

  @doc """
  Return true if cave is small and already visited, otherwise false

  Needs to work for one or two chars long caves. Assumes both letters are either downcase or
  lowercase mixed chars doesn't make sense so it is checking only the first letter.

  If third argument if `false` always returns `false` (unless point is `"start"`)

  ## Examples

      iex> AdventOfCode.Year2021.Day12.avoid?("a", ["a", "b"])
      true
      iex> AdventOfCode.Year2021.Day12.avoid?("a", ["c", "b"])
      false
      iex> AdventOfCode.Year2021.Day12.avoid?("ab", ["ab", "bb"])
      true
      iex> AdventOfCode.Year2021.Day12.avoid?("ab", ["aa", "bb"])
      false
      iex> AdventOfCode.Year2021.Day12.avoid?("A", ["A", "aa"])
      false
      iex> AdventOfCode.Year2021.Day12.avoid?("AB", ["AB", "aa"])
      false
  """
  def avoid?(point, path, double \\ true)
  def avoid?("start", _path, _double), do: true
  def avoid?(<<a::8>> = point, path, true) when a >= ?a and a <= ?z, do: point in path
  def avoid?(<<a::8, _b::8>> = point, path, true) when a >= ?a and a <= ?z, do: point in path
  def avoid?(_point, _path, _double), do: false
end
