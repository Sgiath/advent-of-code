defmodule AdventOfCode.Year2024.Day03 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/3
  """
  use AdventOfCode, year: 2024, day: 03

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """
  end

  def parse(input) do
    ~r/(mul\(\d+\,\d+\))|(do\(\))|(don't\(\))/
    |> Regex.scan(input)
    |> Enum.map(fn [match | _rest] ->
      String.split(match, ["(", ")", ","], trim: true)
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn
      ["mul", a, b] -> String.to_integer(a) * String.to_integer(b)
      _otherwise -> 0
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
    |> run()
  end

  def run(mem, result \\ 0, enabled \\ true)

  # do instruction enables flag
  def run([["do"] | mem], result, _enabled), do: run(mem, result, true)

  # don't instruction disables flag
  def run([["don't"] | mem], result, _enabled), do: run(mem, result, false)

  # multiplication happens with enabled flag
  def run([["mul", a, b] | mem], result, true) do
    run(mem, result + String.to_integer(a) * String.to_integer(b), true)
  end

  # ignore multiplication with disabled flag
  def run([_disabled | mem], result, false), do: run(mem, result, false)

  # end of the program
  def run([], result, _enabled), do: result
end
