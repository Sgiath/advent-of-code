defmodule AdventOfCode.Year2023.Day01 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/1
  """
  use AdventOfCode, year: 2023, day: 01

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input, do: test_input2()

  def test_input1 do
    """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
  end

  def test_input2 do
    """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn line ->
      data =
        line
        |> Enum.reject(fn char -> char > ?9 end)
        |> Enum.map(&(&1 - ?0))

      List.first(data) * 10 + List.last(data)
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
    |> Enum.map(fn line ->
      find_first(line) * 10 + (line |> Enum.reverse() |> find_last())
    end)
    |> Enum.sum()
  end

  def find_first([digit | _rest]) when digit >= ?0 and digit <= ?9, do: digit - ?0
  def find_first([?o, ?n, ?e | _rest]), do: 1
  def find_first([?t, ?w, ?o | _rest]), do: 2
  def find_first([?t, ?h, ?r, ?e, ?e | _rest]), do: 3
  def find_first([?f, ?o, ?u, ?r | _rest]), do: 4
  def find_first([?f, ?i, ?v, ?e | _rest]), do: 5
  def find_first([?s, ?i, ?x | _rest]), do: 6
  def find_first([?s, ?e, ?v, ?e, ?n | _rest]), do: 7
  def find_first([?e, ?i, ?g, ?h, ?t | _rest]), do: 8
  def find_first([?n, ?i, ?n, ?e | _rest]), do: 9
  def find_first([_first | rest]), do: find_first(rest)

  def find_last([digit | _rest]) when digit >= ?0 and digit <= ?9, do: digit - ?0
  def find_last([?e, ?n, ?o | _rest]), do: 1
  def find_last([?o, ?w, ?t | _rest]), do: 2
  def find_last([?e, ?e, ?r, ?h, ?t | _rest]), do: 3
  def find_last([?r, ?u, ?o, ?f | _rest]), do: 4
  def find_last([?e, ?v, ?i, ?f | _rest]), do: 5
  def find_last([?x, ?i, ?s | _rest]), do: 6
  def find_last([?n, ?e, ?v, ?e, ?s | _rest]), do: 7
  def find_last([?t, ?h, ?g, ?i, ?e | _rest]), do: 8
  def find_last([?e, ?n, ?i, ?n | _rest]), do: 9
  def find_last([_first | rest]), do: find_last(rest)
end
