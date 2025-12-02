defmodule AdventOfCode.Year2025.Day02 do
  @moduledoc ~S"""
  https://adventofcode.com/2025/day/2
  """
  use AdventOfCode, year: 2025, day: 02

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    """
  end

  def parse(input) do
    input
    |> String.trim_trailing()
    |> String.split(["-", ","], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.flat_map(fn [a, b] -> String.to_integer(a)..String.to_integer(b) end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.filter(fn number ->
      digits = Integer.digits(number)
      n = length(digits)

      # Must have even digit count, then check if first half equals second half
      # Pattern length = n/2 means exactly 2 repetitions
      rem(n, 2) == 0 and repeating_pattern?(digits, div(n, 2))
    end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.filter(fn number ->
      digits = Integer.digits(number)
      n = length(digits)

      # Need at least 2 digits to have a repeated pattern
      # Pattern length can be at most n/2 (for 2 repetitions)
      # Pattern length must divide n evenly (e.g., 6 digits can have patterns of 1, 2, or 3)
      n >= 2 and
        Enum.any?(1..div(n, 2), fn len ->
          rem(n, len) == 0 and repeating_pattern?(digits, len)
        end)
    end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # Checks if all chunks of size `len` in `digits` are identical.
  defp repeating_pattern?(digits, len) do
    # Split digits into chunks
    [pattern | rest] = Enum.chunk_every(digits, len)

    # Check if every subsequent chunk matches the first one
    Enum.all?(rest, &(&1 == pattern))
  end
end
