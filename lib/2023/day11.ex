defmodule AdventOfCode.Year2023.Day11 do
  @moduledoc ~S"""
  https://adventofcode.com/2023/day/11
  """
  use AdventOfCode, year: 2023, day: 11

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """
  end

  def parse(input) do
    map =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(&(&1 |> String.graphemes()))

    empty_rows =
      map
      |> Enum.with_index()
      |> Enum.filter(fn {line, _i} -> Enum.all?(line, &(&1 == ".")) end)
      |> Enum.map(fn {_line, i} -> i end)

    empty_columns =
      map
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.with_index()
      |> Enum.filter(fn {line, _i} -> Enum.all?(line, &(&1 == ".")) end)
      |> Enum.map(fn {_line, i} -> i end)

    expand(map, empty_rows, empty_columns)
  end

  def expand(map, rows, columns) do
    map
    |> expand_rows(rows, 0)
    |> expand_columns(columns)
  end

  def expand_rows(map, [], _add), do: map

  def expand_rows(map, [row | rest], add) do
    map
    |> List.insert_at(row + add, Enum.at(map, row + add))
    |> expand_rows(rest, add + 1)
  end

  def expand_columns(map, []), do: map

  def expand_columns(map, [col | rest]) do
    map
    |> Enum.map(fn line -> List.insert_at(line, col, ".") end)
    |> expand_columns(rest)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    [first | _rest] = map = parse(input)
    l = length(first)

    map
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.filter(fn {v, _i} -> v == "#" end)
    |> Enum.map(fn {"#", i} -> {div(i, l) + 1, rem(i, l) + 1} end)
    |> Enum.with_index(1)
    |> make_pairs()
    |> Enum.map(fn [{{x1, y1}, i1}, {{x2, y2}, i2}] ->
      {i1, i2, abs(x1 - x2) + abs(y1 - y2) - 1}
    end)
    |> Enum.map(fn {_i1, _i2, l} -> l end)
    |> Enum.sum()
    |> dbg()
  end

  def make_pairs(points, acc \\ [])
  def make_pairs([], acc), do: acc

  def make_pairs([first | rest], acc) do
    n = Enum.map(rest, fn v -> [v, first] end)

    make_pairs(rest, acc ++ n)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    [first | _rest] = map = parse(input)
    l = length(first)

    map
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.filter(fn {v, _i} -> v == "#" end)
    |> Enum.map(fn {"#", i} -> {div(i, l), rem(i, l)} end)
    |> dbg()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================
end
