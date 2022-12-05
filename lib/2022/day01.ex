defmodule AdventOfCode.Year2022.Day01 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/1
  """
  use AdventOfCode

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """
  end

  @impl AdventOfCode
  def input do
    :advent_of_code
    |> Application.app_dir(["priv", "2022", "day01.in"])
    |> File.read!()
  end

  def parse(input) do
    input
    |> String.split(["\n\n"], trim: true)
    |> Enum.map(fn calories ->
      calories
      |> String.split(["\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.max()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
