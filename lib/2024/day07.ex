defmodule AdventOfCode.Year2024.Day07 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/7
  """
  use AdventOfCode, year: 2024, day: 07

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(fn row ->
      [result | numbers] = String.split(row, [":", " "], trim: true)

      {String.to_integer(result), Enum.map(numbers, &String.to_integer/1)}
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @part1_operators [&Kernel.+/2, &Kernel.*/2]

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> sum_solvable(@part1_operators)
  end

  # benchmarks revealed that sync is faster for part 1
  def sum_solvable(equations, operators) do
    equations
    |> Enum.map(fn {result, _nums} = equation ->
      if solvable?(equation, operators), do: result, else: 0
    end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @part2_operators [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat_length/2]

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> async_sum_solvable(@part2_operators)
  end

  # takes about 1100 ms for sync part 2
  def concat_string(a, b), do: String.to_integer("#{a}#{b}")
  # takes about 800 ms for sync part 2
  def concat_digits(a, b), do: Integer.undigits(Integer.digits(a) ++ Integer.digits(b))
  # takes about 360 ms for sync part 2
  def concat_length(a, b), do: a * 10 ** length(Integer.digits(b)) + b
  # takes about 410 ms for sync part 2
  def concat_log(a, b), do: a * 10 ** (floor(:math.log10(b)) + 1) + b

  # benchmarks shows that part 2 is faster with async operations
  def async_sum_solvable(equations, operators) do
    equations
    |> Task.async_stream(fn {result, _nums} = equation ->
      if solvable?(equation, operators), do: result, else: 0
    end)
    |> Enum.reduce(0, fn {:ok, num}, acc -> num + acc end)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # down to one numer which is same as result
  def solvable?({result, [result]}, _operators), do: true
  # down to one number which is different then result
  def solvable?({_result, [_other]}, _operators), do: false
  # check all operations recursively
  def solvable?({result, [a, b | rest]}, operators) do
    Enum.any?(operators, &solvable?({result, [&1.(a, b) | rest]}, operators))
  end

  # ===============================================================================================
  # Benchmark
  # ===============================================================================================

  @impl AdventOfCode
  def bench do
    string_op = [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat_string/2]
    digit_op = [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat_digits/2]
    length_op = [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat_length/2]
    log_op = [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat_log/2]

    [
      %{
        part1_sync: &(&1 |> parse() |> sum_solvable(@part1_operators)),
        part1_async: &(&1 |> parse() |> async_sum_solvable(@part1_operators))
      },
      %{
        part2_string: &(&1 |> parse() |> async_sum_solvable(string_op)),
        part2_digits: &(&1 |> parse() |> async_sum_solvable(digit_op)),
        part2_length: &(&1 |> parse() |> async_sum_solvable(length_op)),
        part2_log: &(&1 |> parse() |> async_sum_solvable(log_op))
      }
    ]
  end
end
