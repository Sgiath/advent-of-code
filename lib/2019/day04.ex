defmodule AdventOfCode.Year2019.Day04 do
  @moduledoc """
  https://adventofcode.com/2019/day/4
  """
  use AdventOfCode, year: 2019, day: 04

  @impl AdventOfCode
  def input do
    Stream.map(168_630..718_098, &Integer.to_charlist/1)
  end

  @impl AdventOfCode
  def part1(input) do
    input
    |> Stream.filter(&increasing?/1)
    |> Stream.filter(&same_digits?/1)
    |> Enum.count()
  end

  @impl AdventOfCode
  def part2(input) do
    input
    |> Stream.filter(&increasing?/1)
    |> Stream.filter(&one_two_digit_group?/1)
    |> Enum.count()
  end

  def increasing?([dig1, dig2 | rest]) when dig1 <= dig2, do: increasing?([dig2 | rest])
  def increasing?([_single_digit]), do: true
  def increasing?(_), do: false

  def same_digits?(code), do: Enum.count(Enum.dedup(code)) < 6

  def one_two_digit_group?(code) do
    code
    |> Enum.chunk_by(& &1)
    |> Enum.any?(&(length(&1) == 2))
  end
end
