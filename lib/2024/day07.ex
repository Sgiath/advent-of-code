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

  @part2_operators [&Kernel.+/2, &Kernel.*/2, &__MODULE__.concat/2]

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> async_sum_solvable(@part2_operators)
  end

  # concat operation
  def concat(a, b), do: String.to_integer("#{a}#{b}")

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
    [
      %{
        part1_sync: &(&1 |> parse() |> sum_solvable(@part1_operators)),
        part1_async: &(&1 |> parse() |> async_sum_solvable(@part1_operators))
      },
      %{
        part2_sync: &(&1 |> parse() |> sum_solvable(@part2_operators)),
        part2_async: &(&1 |> parse() |> async_sum_solvable(@part2_operators))
      }
    ]
  end
end
