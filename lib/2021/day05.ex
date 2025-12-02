defmodule AdventOfCode.Year2021.Day05 do
  @moduledoc """
  https://adventofcode.com/2021/day/5
  """
  use AdventOfCode, year: 2021, day: 5

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
  end

  def parse(input) do
    input
    |> AdventOfCode.Parser.lines([",", " -> ", "\n"])
    |> Enum.chunk_every(4)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.filter(&straight_line?/1)
    |> count_intersections()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> count_intersections()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  # Check if line is horizontal or vertical (not diagonal)
  defp straight_line?([x, _, x, _]), do: true
  defp straight_line?([_, y, _, y]), do: true
  defp straight_line?(_), do: false

  # Count intersections using ETS for fast mutable counter updates.
  # Track intersections on-the-fly: when a point goes from count 1 to 2, it's a new intersection.
  defp count_intersections(lines) do
    table = :ets.new(:points, [:set, :private])

    try do
      Enum.reduce(lines, 0, fn line, acc ->
        acc + add_line_to_ets(line, table)
      end)
    after
      :ets.delete(table)
    end
  end

  # Add all points of a vertical line; return count of new intersections
  defp add_line_to_ets([x, y1, x, y2], table) do
    Enum.reduce(range(y1, y2), 0, fn y, acc ->
      # update_counter returns the new value after incrementing
      if :ets.update_counter(table, {x, y}, 1, {{x, y}, 0}) == 2, do: acc + 1, else: acc
    end)
  end

  # Add all points of a horizontal line; return count of new intersections
  defp add_line_to_ets([x1, y, x2, y], table) do
    Enum.reduce(range(x1, x2), 0, fn x, acc ->
      if :ets.update_counter(table, {x, y}, 1, {{x, y}, 0}) == 2, do: acc + 1, else: acc
    end)
  end

  # Add all points of a diagonal line; return count of new intersections
  defp add_line_to_ets([x1, y1, x2, y2], table) do
    dx = sign(x2 - x1)
    dy = sign(y2 - y1)
    len = abs(x2 - x1)

    Enum.reduce(0..len, 0, fn i, acc ->
      key = {x1 + i * dx, y1 + i * dy}
      if :ets.update_counter(table, key, 1, {key, 0}) == 2, do: acc + 1, else: acc
    end)
  end

  defp sign(n) when n > 0, do: 1
  defp sign(n) when n < 0, do: -1
end
