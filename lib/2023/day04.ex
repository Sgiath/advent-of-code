defmodule AdventOfCode.Year2023.Day04 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/4
  """
  use AdventOfCode, year: 2023, day: 04

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """
  end

  def parse(input) do
    lines = String.split(input, ["\n"], trim: true)

    Enum.map(lines, fn line ->
      ["Card " <> id, w_values, values] = String.split(line, [": ", " | "], trim: true)

      {id |> String.trim() |> String.to_integer(), to_values(w_values), to_values(values)}
    end)
  end

  def to_values(values) do
    values
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&points/1)
    |> Enum.sum()
  end

  def points({_id, w, h}) do
    Enum.reduce(h, 0, fn
      value, 0 -> if value in w, do: 1, else: 0
      value, acc -> if value in w, do: acc * 2, else: acc
    end)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&wins/1)
    |> Enum.reduce(%{}, fn
      {id, 0}, acc ->
        Map.update(acc, id, 1, &(&1 + 1))

      {id, wins}, acc ->
        for i <- 1..wins, reduce: Map.update(acc, id, 1, &(&1 + 1)) do
          acc -> Map.update(acc, id + i, Map.get(acc, id), &(&1 + Map.get(acc, id)))
        end
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def wins({id, w, h}) do
    wins =
      Enum.reduce(h, 0, fn
        value, acc -> if value in w, do: acc + 1, else: acc
      end)

    {id, wins}
  end
end
