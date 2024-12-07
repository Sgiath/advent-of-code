defmodule AdventOfCode.Year2024.Day07 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/7
  """
  use AdventOfCode, year: 2024, day: 07

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn row ->
      [result | numbers] = String.split(row, [":", " "], trim: true)

      {String.to_integer(result), Enum.map(numbers, &String.to_integer/1)}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn {result, _nums} = equation ->
      if solvable1?(equation), do: result, else: 0
    end)
    |> Enum.sum()
  end

  def solvable1?({result, [result]}), do: true
  def solvable1?({_result, [_other]}), do: false

  def solvable1?({result, [a, b | rest]}) do
    solvable1?({result, [a + b | rest]}) or solvable1?({result, [a * b | rest]})
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(fn {result, _nums} = equation ->
      if solvable2?(equation), do: result, else: 0
    end)
    |> Enum.sum()
  end

  def solvable2?({result, [result]}), do: true
  def solvable2?({_result, [_other]}), do: false

  def solvable2?({result, [a, b | rest]}) do
    solvable2?({result, [a + b | rest]}) or
      solvable2?({result, [a * b | rest]}) or
      solvable2?({result, [String.to_integer(to_string(a) <> to_string(b)) | rest]})
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end
