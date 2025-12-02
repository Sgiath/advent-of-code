defmodule AdventOfCode.Year2024.Day11 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/11

  Key insight: stones with the same value always transform identically, so we only need to track
  counts of unique stone values (frequency map), not individual stones. This reduces complexity
  from exponential to linear in the number of unique stone values per blink.
  """
  use AdventOfCode, year: 2024, day: 11

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    125 17
    """
  end

  def parse(input) do
    input
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> blink(25)
    |> count_stones()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> blink(75)
    |> count_stones()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  @doc """
  Simulate the given number of blinks on a frequency map of stone values.
  """
  def blink(stones, 0), do: stones

  def blink(stones, n) do
    stones
    |> Enum.reduce(%{}, fn {value, count}, acc ->
      # Transform each unique stone value and add its count to the new values
      value
      |> transform()
      |> Enum.reduce(acc, fn new_value, inner_acc ->
        Map.update(inner_acc, new_value, count, &(&1 + count))
      end)
    end)
    |> blink(n - 1)
  end

  @doc """
  Transform a single stone value according to the rules:
  - 0 becomes 1
  - Even digit count: split into two stones
  - Otherwise: multiply by 2024
  """
  def transform(0), do: [1]

  def transform(num) do
    # Count digits using logarithm (faster than Integer.digits for large numbers)
    digit_count = digit_count(num)

    if rem(digit_count, 2) == 0 do
      # Split the number in half
      divisor = pow10(div(digit_count, 2))
      [div(num, divisor), rem(num, divisor)]
    else
      [num * 2024]
    end
  end

  # Count digits using integer logarithm
  defp digit_count(n) when n < 10, do: 1
  defp digit_count(n) when n < 100, do: 2
  defp digit_count(n) when n < 1_000, do: 3
  defp digit_count(n) when n < 10_000, do: 4
  defp digit_count(n) when n < 100_000, do: 5
  defp digit_count(n) when n < 1_000_000, do: 6
  defp digit_count(n) when n < 10_000_000, do: 7
  defp digit_count(n) when n < 100_000_000, do: 8
  defp digit_count(n) when n < 1_000_000_000, do: 9
  defp digit_count(n) when n < 10_000_000_000, do: 10
  defp digit_count(n) when n < 100_000_000_000, do: 11
  defp digit_count(n) when n < 1_000_000_000_000, do: 12
  defp digit_count(n) when n < 10_000_000_000_000, do: 13
  defp digit_count(n) when n < 100_000_000_000_000, do: 14
  defp digit_count(n), do: floor(:math.log10(n)) + 1

  # Powers of 10 lookup (faster than :math.pow for integers)
  defp pow10(1), do: 10
  defp pow10(2), do: 100
  defp pow10(3), do: 1_000
  defp pow10(4), do: 10_000
  defp pow10(5), do: 100_000
  defp pow10(6), do: 1_000_000
  defp pow10(7), do: 10_000_000
  defp pow10(n), do: trunc(:math.pow(10, n))

  @doc """
  Sum all stone counts in the frequency map.
  """
  def count_stones(stones) do
    stones
    |> Map.values()
    |> Enum.sum()
  end
end
