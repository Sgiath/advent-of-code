defmodule AdventOfCode.Year2019.Day01 do
  @moduledoc """
  https://adventofcode.com/2019/day/1
  """
  use AdventOfCode, year: 2019, day: 01

  @doc """
  What is the sum of the fuel requirements for all of the modules on your spacecraft?
  """
  @impl AdventOfCode
  def part1 do
    input_numbers()
    |> Stream.map(&calculate_fuel/1)
    |> Enum.sum()
  end

  @doc """
  What is the sum of the fuel requirements for all of the modules on your spacecraft when also
  taking into account the mass of the added fuel? (Calculate the fuel requirements for each
  module separately, then add them all up at the end.)
  """
  @impl AdventOfCode
  def part2 do
    input_numbers()
    |> Stream.map(&calculate_all_fuel/1)
    |> Enum.sum()
  end

  @doc """
  Function that takes mass and calculates required fuel

  # Examples

  iex> AdventOfCode.Year2019.Day01.calculate_fuel(12)
  2

  iex> AdventOfCode.Year2019.Day01.calculate_fuel(14)
  2

  iex> AdventOfCode.Year2019.Day01.calculate_fuel(1969)
  654

  iex> AdventOfCode.Year2019.Day01.calculate_fuel(100756)
  33_583
  """
  @spec calculate_fuel(mass :: integer()) :: integer()
  def calculate_fuel(mass) when is_integer(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  @doc """
  Function that takes mass and calculates required fuel and than recursively required fuel for
  that fuel. Stop condition is when mass is less than 9 than required fuel is 0.

  # Examples

  iex> AdventOfCode.Year2019.Day01.calculate_all_fuel(14)
  2

  iex> AdventOfCode.Year2019.Day01.calculate_all_fuel(1969)
  654 + 216 + 70 + 21 + 5

  iex> AdventOfCode.Year2019.Day01.calculate_all_fuel(100756)
  33_583 + 11_192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2
  """
  @spec calculate_all_fuel(mass :: integer()) :: integer()
  def calculate_all_fuel(mass) when mass < 9, do: 0

  def calculate_all_fuel(mass) when is_integer(mass) do
    needed_fuel = calculate_fuel(mass)

    needed_fuel + calculate_all_fuel(needed_fuel)
  end
end
