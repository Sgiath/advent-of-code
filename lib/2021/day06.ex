defmodule AdventOfCode.Year2021.Day06 do
  @moduledoc """
  https://adventofcode.com/2021/day/6
  """
  use AdventOfCode, year: 2021, day: 06

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
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> simulate(80)
    |> count_fish()
  end

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
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

  # ===============================================================================================
  # Mathematical solution
  # ===============================================================================================

  import Nx, only: :sigils

  # matrice for 1 day
  @transform ~M"""
  0 0 0 0 0 0 1 0 1
  1 0 0 0 0 0 0 0 0
  0 1 0 0 0 0 0 0 0
  0 0 1 0 0 0 0 0 0
  0 0 0 1 0 0 0 0 0
  0 0 0 0 1 0 0 0 0
  0 0 0 0 0 1 0 0 0
  0 0 0 0 0 0 1 0 0
  0 0 0 0 0 0 0 1 0
  """

  # precomputed matrice for 80 days
  @matrix_80 1..79
             |> Enum.reduce(@transform, fn _index, acc -> Nx.dot(acc, @transform) end)
             |> Nx.sum(axes: [1])
             |> Nx.slice([0], [6])

  def matrix_80(input) do
    input =
      input
      |> String.split([",", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    0..5
    |> Enum.map(&(input[&1] || 0))
    |> Nx.tensor()
    |> Nx.dot(@matrix_80)
    |> Nx.to_number()
  end

  # precomputed matrice for 256 days
  @matrix_256 1..255
              |> Enum.reduce(@transform, fn _index, acc -> Nx.dot(acc, @transform) end)
              |> Nx.sum(axes: [1])
              |> Nx.slice([0], [6])

  def matrix_256(input) do
    input =
      input
      |> String.split([",", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()

    0..5
    |> Enum.map(&(input[&1] || 0))
    |> Nx.tensor()
    |> Nx.dot(@matrix_256)
    |> Nx.to_number()
  end

  # ===============================================================================================
  # Benchmark
  # ===============================================================================================

  @impl AdventOfCode
  def bench do
    [
      %{
        recursion: &part1/1,
        matrix: &matrix_80/1
      },
      %{
        recursion: &part2/1,
        matrix: &matrix_256/1
      }
    ]
  end
end
