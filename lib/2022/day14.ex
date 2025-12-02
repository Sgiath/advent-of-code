defmodule AdventOfCode.Year2022.Day14 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/14

  ## Optimization Notes

  The key optimization is **path backtracking**. Instead of restarting each sand grain
  from (500, 0), we track the falling path in a stack. When sand settles, we backtrack
  to the previous position (which will now try alternate directions since the one
  we just came from is blocked). This transforms the algorithm from O(n * h) to O(n + h)
  where n = number of grains and h = depth.
  """
  use AdventOfCode, year: 2022, day: 14

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
    """
  end

  def parse(input) do
    rocks =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&fill_gaps/1)
      |> List.flatten()

    lowest =
      rocks
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    {Enum.into(rocks, MapSet.new()), lowest}
  end

  def parse_line(line) do
    line
    |> String.split([",", " -> "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def fill_gaps(line, acc \\ [])

  def fill_gaps([{x1, y1}, {x2, y2} | rest], acc) do
    acc =
      for x <- range(x1, x2), y <- range(y1, y2), reduce: acc do
        acc -> [{x, y} | acc]
      end

    fill_gaps([{x2, y2} | rest], acc)
  end

  def fill_gaps([_last_point], acc), do: acc

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {rocks, lowest} = parse(input)
    rock_count = MapSet.size(rocks)

    # Path-based simulation: track path as stack, backtrack when sand settles
    final_size = simulate1(rocks, lowest, [{500, 0}])
    final_size - rock_count
  end

  # Sand fell into abyss - simulation complete
  defp simulate1(world, lowest, [{_x, y} | _path]) when y > lowest do
    MapSet.size(world)
  end

  defp simulate1(world, lowest, [{x, y} | rest] = path) do
    down = {x, y + 1}
    down_left = {x - 1, y + 1}
    down_right = {x + 1, y + 1}

    cond do
      # Try to move down
      not MapSet.member?(world, down) ->
        simulate1(world, lowest, [down | path])

      # Try to move down-left
      not MapSet.member?(world, down_left) ->
        simulate1(world, lowest, [down_left | path])

      # Try to move down-right
      not MapSet.member?(world, down_right) ->
        simulate1(world, lowest, [down_right | path])

      # Sand settles at current position - add to world and backtrack
      true ->
        simulate1(MapSet.put(world, {x, y}), lowest, rest)
    end
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {rocks, lowest} = parse(input)
    rock_count = MapSet.size(rocks)
    floor = lowest + 2

    final_size = simulate2(rocks, floor, [{500, 0}])
    final_size - rock_count
  end

  # Path is empty - source is blocked, simulation complete
  defp simulate2(world, _floor, []) do
    MapSet.size(world)
  end

  defp simulate2(world, floor, [{x, y} | rest] = path) do
    down = {x, y + 1}
    down_left = {x - 1, y + 1}
    down_right = {x + 1, y + 1}

    cond do
      # Sand is at floor level - settles immediately
      y + 1 == floor ->
        simulate2(MapSet.put(world, {x, y}), floor, rest)

      # Try to move down
      not MapSet.member?(world, down) ->
        simulate2(world, floor, [down | path])

      # Try to move down-left
      not MapSet.member?(world, down_left) ->
        simulate2(world, floor, [down_left | path])

      # Try to move down-right
      not MapSet.member?(world, down_right) ->
        simulate2(world, floor, [down_right | path])

      # Sand settles at current position - add to world and backtrack
      true ->
        simulate2(MapSet.put(world, {x, y}), floor, rest)
    end
  end
end
