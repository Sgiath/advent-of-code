defmodule AdventOfCode.Year2022.Day06 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/6
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day06.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> List.first()
    |> String.graphemes()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.find_index(fn list -> length(list) == length(Enum.uniq(list)) end)
    |> Kernel.+(4)
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.chunk_every(14, 1, :discard)
    |> Enum.find_index(fn list -> length(list) == length(Enum.uniq(list)) end)
    |> Kernel.+(14)
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================
end
