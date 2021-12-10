defmodule AdventOfCode.Year2021.Day07 do
  @moduledoc """
  https://adventofcode.com/2021/day/7
  """
  use AdventOfCode, year: 2021, day: 07

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input, do: input_data()

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input =
      input
      |> String.split([",", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)

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
    input =
      input
      |> String.split([",", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)

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
