defmodule AdventOfCode.Year2024.Day08 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/8
  """
  use AdventOfCode, year: 2024, day: 08

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """
  end

  def parse(input) do
    # get map with each x, y position
    map =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.map(fn {val, x} -> {val, {x, y}} end)
      end)

    # size of the map (it is always square)
    l = length(map)

    # get only antenas positions grouped by type
    antenas =
      map
      |> List.flatten()
      |> Enum.reject(fn {v, _pos} -> v == ?. end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.map(fn {_type, coords} -> coords end)

    {antenas, l}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {antenas, size} = parse(input)

    antenas
    |> Enum.flat_map(fn coords ->
      coords
      |> pairs(coords, [])
      |> Enum.map(&antinodes_one/1)
    end)
    |> Enum.reject(fn {x, y} ->
      x < 0 or y < 0 or x >= size or y >= size
    end)
    |> Enum.into(MapSet.new())
    |> MapSet.size()
  end

  # extend one antinode since the points are duplicated with the points reversed
  def antinodes_one({{x1, y1}, {x2, y2}}) do
    vx = x1 - x2
    vy = y1 - y2

    {x1 + vx, y1 + vy}
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {antenas, size} = parse(input)

    antenas
    |> Enum.flat_map(fn coords ->
      coords
      |> pairs(coords, [])
      |> Enum.flat_map(&antinodes_all(&1, size))
    end)
    |> Enum.into(MapSet.new())
    |> MapSet.size()
  end

  # extend all antinodes at each side of antenas
  # the pairs are duplicated with the points reversed, so we need to extend only one side
  def antinodes_all({{x1, y1}, {x2, y2}}, size) do
    vx = x1 - x2
    vy = y1 - y2

    [{x1, y1} | extend({x1, y1}, {vx, vy}, size)]
  end

  # recursively extend the point with vector until border is reached
  def extend({x, y}, {vx, vy}, size) do
    nx = x + vx
    ny = y + vy

    if nx >= 0 and ny >= 0 and nx < size and ny < size do
      [{nx, ny} | extend({nx, ny}, {vx, vy}, size)]
    else
      []
    end
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  # get list of all pairs for two lists (the pairs are duplicated but that is fine)
  def pairs([], _all, result), do: result
  def pairs([a | rest], all, result), do: pairs(rest, all, result ++ pairs(a, all))

  # get list of all pairs for a single value and list
  def pairs(_a, []), do: []
  def pairs(a, [a | rest]), do: pairs(a, rest)
  def pairs(a, [b | rest]), do: [{a, b} | pairs(a, rest)]
end
