defmodule AdventOfCode.Year2024.Day12 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/12
  """
  use AdventOfCode, year: 2024, day: 12

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    [
      """
      AAAA
      BBCD
      BBCC
      EEEC
      """,
      """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      """,
      """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
      """
    ]
  end

  def parse(input) do
    map =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.map(fn {val, x} -> {val, {x, y}} end)
      end)

    l = length(map)

    {List.flatten(map), l}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> dbg()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end
