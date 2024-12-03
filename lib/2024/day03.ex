defmodule AdventOfCode.Year2024.Day03 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/3
  """
  use AdventOfCode, year: 2024, day: 03

  import NimbleParsec

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """
  end

  @doc """
  Original parsing through regex
  """
  def parse_regex(input) do
    ~r/(mul\(\d+\,\d+\))|(do\(\))|(don't\(\))/
    |> Regex.scan(input)
    |> Enum.map(fn [match | _rest] ->
      String.split(match, ["(", ")", ","], trim: true)
    end)
    |> Enum.map(fn
      ["mul", a, b] -> {:mul, [String.to_integer(a), String.to_integer(b)]}
      ["do"] -> {:do, []}
      ["don't"] -> {:dont, []}
    end)
  end

  # new parsing using NimbleParsec

  mul =
    ignore(string("mul("))
    |> integer(min: 1, max: 3)
    |> ignore(string(","))
    |> integer(min: 1, max: 3)
    |> ignore(string(")"))
    |> tag(:mul)

  enable =
    ignore(string("do()"))
    |> tag(:do)

  disable =
    ignore(string("don't()"))
    |> tag(:dont)

  defparsec :program, choice([mul, enable, disable]) |> eventually() |> repeat()

  def parse(input) do
    {:ok, instructions, _rest, _context, _line, _offset} = program(input)

    instructions
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> run1()
  end

  @doc """
  Take into account only mul instruction
  """
  def run1(mem, result \\ 0)
  def run1([{:mul, [a, b]} | mem], result), do: run1(mem, result + a * b)
  def run1([_ignore | mem], result), do: run1(mem, result)
  def run1([], result), do: result

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> run2()
  end

  @doc """
  Take into account also do and dont instructions and track the enabled flag
  """
  def run2(mem, result \\ 0, enabled \\ true)
  def run2([{:do, _args} | mem], result, _enabled), do: run2(mem, result, true)
  def run2([{:dont, _args} | mem], result, _enabled), do: run2(mem, result, false)
  def run2([{:mul, [a, b]} | mem], result, true), do: run2(mem, result + a * b, true)
  def run2([_disabled | mem], result, false), do: run2(mem, result, false)
  def run2([], result, _enabled), do: result

  # ===============================================================================================
  # Benchmark
  # ===============================================================================================

  # wow, regex is 2.6x slower on big input and 4.3x slower on small input

  # ##### With input big #####
  # Name                    ips        average  deviation         median         99th %
  # nimble_parsec       1422.73      702.87 μs    ±14.71%      670.95 μs     1261.56 μs
  # regex                550.09     1817.90 μs     ±5.98%     1777.22 μs     2107.25 μs
  #
  # Comparison:
  # nimble_parsec       1422.73
  # regex                550.09 - 2.59x slower +1115.02 μs

  # ##### With input small #####
  # Name                    ips        average  deviation         median         99th %
  # nimble_parsec      373.24 K        2.68 μs  ±1081.19%        2.54 μs        3.52 μs
  # regex               86.05 K       11.62 μs    ±94.53%       11.52 μs          13 μs
  #
  # Comparison:
  # nimble_parsec      373.24 K
  # regex               86.05 K - 4.34x slower +8.94 μs

  @impl AdventOfCode
  def bench do
    [
      %{
        nimble_parsec: &parse/1,
        regex: &parse_regex/1
      }
    ]
  end
end
