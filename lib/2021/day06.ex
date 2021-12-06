defmodule AdventOfCode.Year2021.Day06 do
  @moduledoc """
  https://adventofcode.com/2021/day/6
  """
  use AdventOfCode, year: 2021, day: 06

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def input do
    input_file()
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> simulate(80)
    |> count_fish()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> simulate(256)
    |> count_fish()
  end

  # ===============================================================================================
  # Utils
  # ===============================================================================================

  @doc """
  Simulate number of days for population
  """
  def simulate(population, 0), do: population

  def simulate(population, days) do
    population
    |> Enum.reduce(%{}, &population_reducer/2)
    |> simulate(days - 1)
  end

  @doc """
  Add population with new timer

  Special case for timer 0 which also needs to add new population with timer 8
  """
  def population_reducer({0, num}, acc) do
    acc
    |> Map.put(8, num)
    |> Map.update(6, num, &(&1 + num))
  end

  def population_reducer({timer, num}, acc) do
    Map.update(acc, timer - 1, num, &(&1 + num))
  end

  @doc """
  Count all fish in population
  """
  def count_fish(population) do
    population
    |> Map.values()
    |> Enum.sum()
  end
end
