defmodule AdventOfCode.Year2021.Day07 do
  @moduledoc """
  https://adventofcode.com/2021/day/7
  """
  use AdventOfCode, year: 2021, day: 7

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    16,1,2,0,4,2,7,1,2,14
    """
  end

  def parse(input) do
    AdventOfCode.Parser.line(input)
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input = parse(input)

    fuel_linear(input, round(Statistics.median(input)))
  end

  def fuel_linear(positions, dest) do
    Enum.reduce(positions, 0, &(abs(&1 - dest) + &2))
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input = parse(input)
    mean = Statistics.mean(input)

    Enum.min([fuel_quadratic(input, floor(mean)), fuel_quadratic(input, ceil(mean))])
  end

  def fuel_quadratic(positions, dest) do
    Enum.reduce(positions, 0, fn pos, acc ->
      d = abs(pos - dest)
      acc + div(d * (d + 1), 2)
    end)
  end
end
