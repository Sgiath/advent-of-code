defmodule AdventOfCode.Year2022.Day06 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/6
  """
  use AdventOfCode, year: 2022, day: 6

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> List.first()
    |> String.graphemes()
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.find_index(&(length(&1) == length(Enum.uniq(&1))))
    |> Kernel.+(4)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.chunk_every(14, 1, :discard)
    |> Enum.find_index(&(length(&1) == length(Enum.uniq(&1))))
    |> Kernel.+(14)
  end
end
