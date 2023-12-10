defmodule AdventOfCode.Year2023.Day09 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/9
  """
  use AdventOfCode, year: 2023, day: 09

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([" "], trim: true)
      |> Enum.map(fn v -> String.to_integer(v) end)
      |> then(&[&1])
      |> extrapolate()
    end)
  end

  def extrapolate([[_first | second] = last | _rest] = values) do
    last
    |> Enum.zip(second)
    |> Enum.map(fn {a, b} -> b - a end)
    |> then(fn new ->
      if Enum.all?(new, &(&1 == 0)) do
        values
      else
        extrapolate([new | values])
      end
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&calc_end(&1, 0))
    |> Enum.sum()
  end

  def calc_end([], add), do: add

  def calc_end([last | rest], add) do
    calc_end(rest, List.last(last) + add)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&calc_start(&1, 0))
    |> Enum.sum()
  end

  def calc_start([], add), do: add

  def calc_start([last | rest], add) do
    calc_start(rest, List.first(last) - add)
  end
end
