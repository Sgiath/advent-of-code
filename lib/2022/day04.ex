defmodule AdventOfCode.Year2022.Day04 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/4
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day04.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n", ",", "-"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&contains?/1)
    |> Enum.count(& &1)
  end

  defp contains?([x1, y1, x2, y2]) when x1 >= x2 and y1 <= y2, do: true
  defp contains?([x1, y1, x2, y2]) when x1 <= x2 and y1 >= y2, do: true
  defp contains?(_data), do: false

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&overlap?/1)
    |> Enum.count(& &1)
  end

  defp overlap?([x1, y1, x2, _y2]) when x1 <= x2 and y1 >= x2, do: true
  defp overlap?([x1, _y1, x2, y2]) when x2 <= x1 and y2 >= x1, do: true
  defp overlap?(_data), do: false
end
