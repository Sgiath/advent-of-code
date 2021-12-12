defmodule AdventOfCode.Year2021.Day12 do
  @moduledoc """
  https://adventofcode.com/2021/day/12
  """
  use AdventOfCode

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

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2021", "day12.in"])
    |> File.read!()
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

  def find_paths(graph, path \\ ["start"])
  def find_paths(_graph, ["end" | _path]), do: :ok

  def find_paths(graph, [point | _rest] = path) do
    graph[point]
    |> Enum.reject(&is_small(&1, path))
    |> Enum.map(&find_paths(graph, [&1 | path]))
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> neighbors()
    |> find_paths2()
    |> List.flatten()
    |> length()
  end

  def find_paths2(graph, path \\ ["start"], double \\ false)
  def find_paths2(_graph, ["end" | _path], _double), do: :ok

  def find_paths2(graph, [point | _rest] = path, double) do
    graph[point]
    |> Enum.reject(&is_small(&1, path, double))
    |> Enum.map(&find_paths2(graph, [&1 | path], double or is_small(&1, path, true)))
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

      iex> AdventOfCode.Year2021.Day12.is_small("a", ["a", "b"])
      true
      iex> AdventOfCode.Year2021.Day12.is_small("a", ["c", "b"])
      false
      iex> AdventOfCode.Year2021.Day12.is_small("ab", ["ab", "bb"])
      true
      iex> AdventOfCode.Year2021.Day12.is_small("ab", ["aa", "bb"])
      false
      iex> AdventOfCode.Year2021.Day12.is_small("A", ["A", "aa"])
      false
      iex> AdventOfCode.Year2021.Day12.is_small("AB", ["AB", "aa"])
      false
  """
  def is_small(point, path, double \\ true)
  def is_small("start", _path, _double), do: true
  def is_small(<<a::8>> = point, path, true) when a >= ?a and a <= ?z, do: point in path
  def is_small(<<a::8, _b::8>> = point, path, true) when a >= ?a and a <= ?z, do: point in path
  def is_small(_point, _path, _double), do: false
end
