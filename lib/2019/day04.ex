defmodule AdventOfCode.Year2019.Day04 do
  @moduledoc """
  https://adventofcode.com/2019/day/4
  """
  use AdventOfCode, year: 2019, day: 4

  @impl AdventOfCode
  def test_input do
    raise "No test input"
  end

  @impl AdventOfCode
  def part1(input) do
    input
    |> String.split(["\n", "-"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(&Range.new(List.first(&1), List.last(&1)))
    |> Enum.map(&Integer.to_charlist/1)
    |> Enum.count(&(increasing?(&1) and same_digits?(&1)))
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> String.split(["\n", "-"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(&Range.new(List.first(&1), List.last(&1)))
    |> Enum.map(&Integer.to_charlist/1)
    |> Enum.count(&(increasing?(&1) and one_two_digit_group?(&1)))
  end

  def increasing?([dig1, dig2 | rest]) when dig1 <= dig2, do: increasing?([dig2 | rest])
  def increasing?([_single_digit]), do: true
  def increasing?(_digits), do: false

  def same_digits?(code), do: Enum.count(Enum.dedup(code)) < 6

  def one_two_digit_group?(code) do
    code
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(length(&1) == 2))
  end
end
