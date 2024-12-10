defmodule AdventOfCode.Year2024.Day10 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/10
  """
  use AdventOfCode, year: 2024, day: 10

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
  end

  def parse(input) do
    map =
      input
      |> String.split(["\n"], trim: true)
      |> Enum.map(fn row ->
        row
        |> String.to_charlist()
        |> Enum.map(&(&1 - ?0))
        |> Enum.with_index()
      end)
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        Enum.map(row, fn {val, x} -> {val, {x, y}} end)
      end)

    l = length(map)

    {List.flatten(map), l}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {map, l} = parse(input)

    map
    |> Enum.filter(fn {val, _pos} -> val == 0 end)
    |> Task.async_stream(fn {0, pos} ->
      {map, l}
      |> trail_heads({0, pos})
      |> List.flatten()
      |> Enum.uniq()
      |> length()
    end)
    |> Enum.reduce(0, fn {:ok, val}, acc -> val + acc end)
  end

  def trail_heads(map, {val, pos}) do
    map
    |> neigh(pos)
    |> Enum.map(fn
      {9, npos} when val == 8 -> npos
      {nval, npos} when nval == val + 1 -> trail_heads(map, {nval, npos})
      _otherwise -> nil
    end)
    |> Enum.reject(&is_nil/1)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {map, l} = parse(input)

    map
    |> Enum.filter(fn {val, _pos} -> val == 0 end)
    |> Task.async_stream(&trails({map, l}, &1))
    |> Enum.reduce(0, fn {:ok, val}, acc -> val + acc end)
  end

  def trails(map, {val, pos}) do
    map
    |> neigh(pos)
    |> Enum.map(fn
      {9, _npos} when val == 8 -> 1
      {nval, npos} when nval == val + 1 -> trails(map, {nval, npos})
      _otherwise -> 0
    end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def get({_map, l}, {x, y}) when x < 0 or y < 0 or x >= l or y >= l, do: nil
  def get({map, l}, {x, y}), do: Enum.at(map, y * l + x)

  def neigh(map, {x, y}) do
    [
      get(map, {x + 1, y}),
      get(map, {x - 1, y}),
      get(map, {x, y - 1}),
      get(map, {x, y + 1})
    ]
  end
end
