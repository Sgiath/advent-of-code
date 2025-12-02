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
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.flat_map(fn {a, b} -> a..b end)
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
    |> Enum.flat_map(fn {a, b} -> a..b end)
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

  # =============================================================================================
  # Generator solution
  # =============================================================================================

  # Instead of checking every number in the ranges, generate only invalid numbers directly
  # and check if they fall within any range. Much faster for large ranges.

  def part1_gen(input) do
    ranges = parse(input)
    {min_val, max_val} = ranges_bounds(ranges)

    generate_pairs(min_val, max_val)
    |> Enum.filter(&in_any_range?(&1, ranges))
    |> Enum.sum()
  end

  def part2_gen(input) do
    ranges = parse(input)
    {min_val, max_val} = ranges_bounds(ranges)

    generate_repeating(min_val, max_val)
    |> Enum.filter(&in_any_range?(&1, ranges))
    |> Enum.sum()
  end

  # Find the overall min and max across all ranges
  defp ranges_bounds(ranges) do
    {min_val, _} = Enum.min_by(ranges, &elem(&1, 0))
    {_, max_val} = Enum.max_by(ranges, &elem(&1, 1))
    {min_val, max_val}
  end

  # Check if a number falls within any of the ranges
  defp in_any_range?(num, ranges) do
    Enum.any?(ranges, fn {lo, hi} -> num >= lo and num <= hi end)
  end

  # Generate all "pairs" invalid numbers (pattern repeated exactly twice)
  # For pattern length L, invalid number = pattern × (10^L + 1)
  # Example: pattern=12, L=2 → 12 × 101 = 1212
  defp generate_pairs(min_val, max_val) do
    Stream.unfold(1, fn len ->
      multiplier = pow10(len) + 1
      pattern_min = max(if(len == 1, do: 1, else: pow10(len - 1)), div_ceil(min_val, multiplier))
      pattern_max = min(pow10(len) - 1, div(max_val, multiplier))

      if pattern_min > pattern_max do
        # No valid patterns at this length, check if we should continue
        if pow10(len) * multiplier > max_val do
          nil
        else
          {[], len + 1}
        end
      else
        numbers = for p <- pattern_min..pattern_max, do: p * multiplier
        {numbers, len + 1}
      end
    end)
    |> Stream.concat()
  end

  # Generate all repeating invalid numbers (pattern repeated 2+ times)
  # Generates patterns of each length repeated k times (k >= 2)
  defp generate_repeating(min_val, max_val) do
    max_digits = Integer.digits(max_val) |> length()

    # For each total digit count from 2 to max_digits
    for total_digits <- 2..max_digits,
        # For each pattern length that divides total_digits and allows 2+ repetitions
        pattern_len <- 1..div(total_digits, 2),
        rem(total_digits, pattern_len) == 0,
        # Generate all valid patterns
        pattern <- pattern_range(pattern_len),
        # Build the repeated number
        num = repeat_pattern(pattern, div(total_digits, pattern_len)),
        # Filter to valid range
        num >= min_val and num <= max_val do
      num
    end
    |> Enum.uniq()
  end

  # Range of valid patterns for a given length (no leading zeros)
  defp pattern_range(1), do: 1..9
  defp pattern_range(len), do: pow10(len - 1)..(pow10(len) - 1)

  # Repeat a pattern k times to form a number
  # Example: repeat_pattern(12, 3) = 121212
  defp repeat_pattern(pattern, times) do
    digits = Integer.digits(pattern)
    len = length(digits)

    Enum.reduce(1..(times - 1), pattern, fn _, acc ->
      acc * pow10(len) + pattern
    end)
  end

  # Fast power of 10
  defp pow10(0), do: 1
  defp pow10(n), do: Integer.pow(10, n)

  # Ceiling division
  defp div_ceil(a, b), do: div(a + b - 1, b)

  # =============================================================================================
  # Benchmarks
  # =============================================================================================

  @impl AdventOfCode
  def bench do
    [
      %{
        part1_brute: &part1/1,
        part1_gen: &part1_gen/1
      },
      %{
        part2_brute: &part2/1,
        part2_gen: &part2_gen/1
      }
    ]
  end
end
