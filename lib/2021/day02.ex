defmodule AdventOfCode.Year2021.Day02 do
  @moduledoc """
  https://adventofcode.com/2021/day/2
  """
  use AdventOfCode, year: 2021, day: 2

  # ===============================================================================================
  # Input
  # ===============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
  end

  # ===============================================================================================
  # Part 1
  # ===============================================================================================

  @impl AdventOfCode
  def part1(input, reducer \\ &count_reducer/2) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.reduce({0, 0}, reducer)
    |> Tuple.product()
  end

  def count_reducer("forward " <> val, {h, d}), do: {h + String.to_integer(val), d}
  def count_reducer("down " <> val, {h, d}), do: {h, d + String.to_integer(val)}
  def count_reducer("up " <> val, {h, d}), do: {h, d - String.to_integer(val)}

  # ===============================================================================================
  # Part 2
  # ===============================================================================================

  @impl AdventOfCode
  def part2(input, reducer \\ &count_aim_reducer/2) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.reduce({0, 0, 0}, reducer)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  def count_aim_reducer("forward " <> val, {h, d, a}),
    do: {h + String.to_integer(val), d + a * String.to_integer(val), a}

  def count_aim_reducer("down " <> val, {h, d, a}), do: {h, d, a + String.to_integer(val)}
  def count_aim_reducer("up " <> val, {h, d, a}), do: {h, d, a - String.to_integer(val)}

  # ===============================================================================================
  # Other solutions
  # ===============================================================================================

  def count_reducer1(<<"forward ", val::8>>, {h, d}), do: {h + (val - ?0), d}
  def count_reducer1(<<"down ", val::8>>, {h, d}), do: {h, d + (val - ?0)}
  def count_reducer1(<<"up ", val::8>>, {h, d}), do: {h, d - (val - ?0)}

  def count_reducer2(<<"f", _rest::56, val::8>>, {h, d}), do: {h + (val - ?0), d}
  def count_reducer2(<<"d", _rest::32, val::8>>, {h, d}), do: {h, d + (val - ?0)}
  def count_reducer2(<<"u", _rest::16, val::8>>, {h, d}), do: {h, d - (val - ?0)}

  # this seems to be the quickest one (but just by few μs)
  def count_reducer3(<<_rest::64, val::8>>, {h, d}), do: {h + (val - ?0), d}
  def count_reducer3(<<_rest::40, val::8>>, {h, d}), do: {h, d + (val - ?0)}
  def count_reducer3(<<_rest::24, val::8>>, {h, d}), do: {h, d - (val - ?0)}

  # ===============================================================================================
  # Benchmarks
  # ===============================================================================================

  @impl AdventOfCode
  def bench do
    %{
      string_matching: &part1/1,
      bitstring_matching: fn input -> part1(input, &count_reducer1/2) end,
      first_letter_matching: fn input -> part1(input, &count_reducer2/2) end,
      length_matching: fn input -> part1(input, &count_reducer3/2) end
    }
  end
end
